package imgui_impl_vulkan

import vk "vendor:vulkan"

import imgui "../.."

import "core:mem"
import "core:log"

@(private="package")
Vulkan_Buffer :: struct {
	buffer: vk.Buffer,
	memory: vk.DeviceMemory,
	size:   vk.DeviceSize,
	ptr:    rawptr,
	offset: uintptr,
}

@(private="package")
Vulkan_Frame_Data :: struct {
	vertices, indices: Vulkan_Buffer,
}

Vulkan_State :: struct {
	device:            vk.Device,
	physical_device:   vk.PhysicalDevice,
	memory_properties: vk.PhysicalDeviceMemoryProperties,
	queue:             vk.Queue,
	queue_family:      u32,

	temp_command_buffer: vk.CommandBuffer,

	font_image:           vk.Image,
	font_memory:          vk.DeviceMemory,
	font_view:            vk.ImageView,
	font_sampler:         vk.Sampler,
	set_layout:           vk.DescriptorSetLayout,
	font_descriptor_pool: vk.DescriptorPool,
	font_descriptor_set:  vk.DescriptorSet,

	frame_datas:       [8]Vulkan_Frame_Data,
	frame_datas_count: int,

	pipeline:        vk.Pipeline,
	pipeline_layout: vk.PipelineLayout,
}

Vulkan_Info :: struct {
	device:          vk.Device,
	physical_device: vk.PhysicalDevice,
	queue:           vk.Queue,
	queue_family:    u32,

	max_frames_in_flight: int,
	compatible_renderpass: vk.RenderPass,
	use_srgb: bool, // If true, will apply gamma correction.
}

@(private="package")
vk_assert :: proc(result: vk.Result) {
	if result == .SUCCESS do return

	log.panicf("VkResult != Success! Was %v", result);
}

setup_state :: proc(using vulkan_state: ^Vulkan_State, info: Vulkan_Info) {
	device          = info.device
	physical_device = info.physical_device
	queue           = info.queue
	queue_family    = info.queue_family

	vk.GetPhysicalDeviceMemoryProperties(physical_device, &memory_properties)

	io := imgui.get_io()
	io.backend_renderer_name = "Vulkan"
	io.backend_flags |= .RendererHasVtxOffset

	pixels_ptr: ^u8
	width, height: i32
	imgui.font_atlas_get_tex_data_as_rgba32(io.fonts, &pixels_ptr, &width, &height)
	pixels := cast([]u8)mem.byte_slice(rawptr(pixels_ptr), cast(int)(width * height * size_of(u32)))

	temp_pool: vk.CommandPool
	vk_assert(vk.CreateCommandPool(device, &vk.CommandPoolCreateInfo {
		sType            = .COMMAND_POOL_CREATE_INFO,
		queueFamilyIndex = queue_family,
	}, nil, &temp_pool))
	defer vk.DestroyCommandPool(device, temp_pool, nil)

	vk_assert(vk.AllocateCommandBuffers(device, &vk.CommandBufferAllocateInfo {
		sType              = .COMMAND_BUFFER_ALLOCATE_INFO,
		commandPool        = temp_pool,
		level              = .PRIMARY,
		commandBufferCount = 1,
	}, &temp_command_buffer))

	vk_assert(vk.BeginCommandBuffer(temp_command_buffer, &vk.CommandBufferBeginInfo {
		sType = .COMMAND_BUFFER_BEGIN_INFO,
		flags = { .ONE_TIME_SUBMIT },
	}))

	image_size := cast(vk.DeviceSize)(width * height * 4)
	staging_buffer, staging_memory := create_buffer(vulkan_state, image_size, {.TRANSFER_SRC}, {.HOST_VISIBLE, .HOST_COHERENT})
	defer vk.DestroyBuffer(device, staging_buffer, nil)
	defer vk.FreeMemory(device, staging_memory, nil)

	defer {
		// Any resources used in this command buffer must be defer-deleted above this line, or vulkan will complain
		vk_assert(vk.EndCommandBuffer(temp_command_buffer))
		vk_assert(vk.QueueSubmit(queue, 1, &vk.SubmitInfo {
			sType              = .SUBMIT_INFO,
			commandBufferCount = 1,
			pCommandBuffers    = &temp_command_buffer,
		}, 0))
		vk_assert(vk.QueueWaitIdle(queue))
	}

	data: rawptr
	vk.MapMemory(device, staging_memory, 0, image_size, {}, &data)
	mem.copy(data, raw_data(pixels), cast(int)image_size)
	vk.UnmapMemory(device, staging_memory)

	extent := vk.Extent3D { cast(u32)width, cast(u32)height, 1 }

	vk_assert(vk.CreateImage(device, &vk.ImageCreateInfo {
		sType         = .IMAGE_CREATE_INFO,
		imageType     = .D2,
		extent        = extent,
		mipLevels     = 1,
		arrayLayers   = 1,
		format        = .R8G8B8A8_UNORM,
		tiling        = .OPTIMAL,
		initialLayout = .UNDEFINED,
		usage         = {.TRANSFER_DST, .SAMPLED},
		sharingMode   = .EXCLUSIVE,
		samples       = {._1},
	}, nil, &font_image))

	font_memory = allocate_image_backing_memory(vulkan_state, font_image, {.DEVICE_LOCAL})

	image_transition_layout(vulkan_state, font_image, .UNDEFINED, .TRANSFER_DST_OPTIMAL)

	vk.CmdCopyBufferToImage(temp_command_buffer, staging_buffer, font_image, .TRANSFER_DST_OPTIMAL, 1, &vk.BufferImageCopy {
		imageSubresource = {
			aspectMask = {.COLOR},
			layerCount = 1,
		},
		imageExtent = extent,
	})

	image_transition_layout(vulkan_state, font_image, .TRANSFER_DST_OPTIMAL, .SHADER_READ_ONLY_OPTIMAL)

	vk_assert(vk.CreateImageView(device, &vk.ImageViewCreateInfo {
		sType            = .IMAGE_VIEW_CREATE_INFO,
		image            = font_image,
		viewType         = .D2,
		format           = .R8G8B8A8_UNORM,
		subresourceRange = {
			aspectMask     = { .COLOR },
			baseMipLevel   = 0,
			levelCount     = 1,
			baseArrayLayer = 0,
			layerCount     = 1,
		},
	}, nil, &font_view))

	vk_assert(vk.CreateSampler(device, &vk.SamplerCreateInfo {
		sType = .SAMPLER_CREATE_INFO,
		magFilter = .LINEAR,
		minFilter = .LINEAR,
		addressModeU = .REPEAT,
		addressModeV = .REPEAT,
		addressModeW = .REPEAT,
		anisotropyEnable = false,
	}, nil, &font_sampler))

	vk_assert(vk.CreateDescriptorSetLayout(device, &vk.DescriptorSetLayoutCreateInfo {
		sType = .DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
		bindingCount = 1,
		pBindings = &vk.DescriptorSetLayoutBinding {
			binding = 0,
			descriptorType = .COMBINED_IMAGE_SAMPLER,
			descriptorCount = 1,
			stageFlags = { .FRAGMENT },
		},
	}, nil, &set_layout))

	vk_assert(vk.CreateDescriptorPool(device, &vk.DescriptorPoolCreateInfo {
		sType = .DESCRIPTOR_POOL_CREATE_INFO,
		maxSets = 1,
		poolSizeCount = 1,
		pPoolSizes = &vk.DescriptorPoolSize {
			type = .COMBINED_IMAGE_SAMPLER,
			descriptorCount = 1,
		},
	}, nil, &font_descriptor_pool))

	vk_assert(vk.AllocateDescriptorSets(device, &vk.DescriptorSetAllocateInfo {
		sType = .DESCRIPTOR_SET_ALLOCATE_INFO,
		descriptorPool = font_descriptor_pool,
		descriptorSetCount = 1,
		pSetLayouts = &set_layout,
	}, &font_descriptor_set))

	vk.UpdateDescriptorSets(device, 1, &vk.WriteDescriptorSet {
		sType           = .WRITE_DESCRIPTOR_SET,
		dstSet          = font_descriptor_set,
		dstBinding      = 0,
		descriptorType  = .COMBINED_IMAGE_SAMPLER,
		descriptorCount = 1,
		pImageInfo = &vk.DescriptorImageInfo {
			sampler     = font_sampler,
			imageView   = font_view,
			imageLayout = .SHADER_READ_ONLY_OPTIMAL,
		},
	}, 0, nil)

	// Texture IDs are assumed to be a descriptor set compatible with the imgui pipeline
	#assert(size_of(imgui.Texture_ID) == size_of(vk.DescriptorSet))
	io.fonts.tex_id = transmute(imgui.Texture_ID)(font_descriptor_set)

	frame_datas_count = info.max_frames_in_flight
	assert(frame_datas_count < len(frame_datas))

	vertex_shader := VERTEX_SHADER_SOURCE
	fragment_shader := FRAGMENT_SHADER_SOURCE

	vertex_module   := create_shader_module(vulkan_state, vertex_shader[:])
	fragment_module := create_shader_module(vulkan_state, fragment_shader[:])
	defer vk.DestroyShaderModule(device, vertex_module, nil)
	defer vk.DestroyShaderModule(device, fragment_module, nil)

	use_srgb_b32 := b32(info.use_srgb)

	modules := []vk.PipelineShaderStageCreateInfo {
		vk.PipelineShaderStageCreateInfo {
			sType = .PIPELINE_SHADER_STAGE_CREATE_INFO,
			stage = {.VERTEX},
			module = vertex_module,
			pName = "main",
		},
		vk.PipelineShaderStageCreateInfo {
			sType = .PIPELINE_SHADER_STAGE_CREATE_INFO,
			stage = {.FRAGMENT},
			module = fragment_module,
			pName = "main",
			pSpecializationInfo = &vk.SpecializationInfo {
				mapEntryCount = 1,
				pMapEntries   = &vk.SpecializationMapEntry {
					constantID = 0, // Whether we expect to draw to SRGB
					offset = 0,
					size = 4,
				},
				dataSize = size_of(b32),
				pData    = &use_srgb_b32,
			},
		},
	}

	binding_description := vk.VertexInputBindingDescription {
		binding = 0,
		stride = size_of(imgui.Draw_Vert),
		inputRate = .VERTEX,
	}

	attribute_descriptions := []vk.VertexInputAttributeDescription {
		{ location = 0, binding = 0, format = .R32G32_SFLOAT,  offset = 0  },
		{ location = 1, binding = 0, format = .R32G32_SFLOAT,  offset = 8  },
		{ location = 2, binding = 0, format = .R8G8B8A8_UNORM, offset = 16 },
	}

	vertex_input_info := vk.PipelineVertexInputStateCreateInfo {
		sType                           = .PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
		vertexBindingDescriptionCount   = 1,
		pVertexBindingDescriptions      = &binding_description,
		vertexAttributeDescriptionCount = cast(u32)len(attribute_descriptions),
		pVertexAttributeDescriptions    = raw_data(attribute_descriptions),
	}

	input_assembly_state := vk.PipelineInputAssemblyStateCreateInfo {
		sType                  = .PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
		topology               = .TRIANGLE_LIST,
		primitiveRestartEnable = false,
	}

	viewport_state := vk.PipelineViewportStateCreateInfo {
		sType         = .PIPELINE_VIEWPORT_STATE_CREATE_INFO,
		viewportCount = 1,
		scissorCount  = 1,
	}

	rasterization_state := vk.PipelineRasterizationStateCreateInfo {
		sType                   = .PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
		depthClampEnable        = false,
		rasterizerDiscardEnable = false,
		polygonMode             = .FILL,
		lineWidth               = 1.0,
		cullMode                = {},
		depthBiasEnable         = false,
	}

	multisample_state := vk.PipelineMultisampleStateCreateInfo {
		sType                 = .PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
		sampleShadingEnable   = false,
		rasterizationSamples  = {._1},
		minSampleShading      = 1.0,
		pSampleMask           = nil,
		alphaToCoverageEnable = false,
		alphaToOneEnable      = false,
	}

	color_blend_state := vk.PipelineColorBlendStateCreateInfo {
		sType           = .PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
		logicOpEnable   = false,
		attachmentCount = 1,
		pAttachments    = &vk.PipelineColorBlendAttachmentState {
			blendEnable         = true,
			srcColorBlendFactor = .SRC_ALPHA,
			dstColorBlendFactor = .ONE_MINUS_SRC_ALPHA,
			srcAlphaBlendFactor = .ONE,
			colorWriteMask      = {.R, .G, .B, .A},
		},
	}

	depth_stencil := vk.PipelineDepthStencilStateCreateInfo {
		sType                 = .PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO,
		depthTestEnable       = false,
		depthWriteEnable      = false,
		depthBoundsTestEnable = false,
		stencilTestEnable     = false,
	}

	dynamic_states := []vk.DynamicState{.VIEWPORT, .SCISSOR}

	dynamic_state := vk.PipelineDynamicStateCreateInfo {
		sType             = .PIPELINE_DYNAMIC_STATE_CREATE_INFO,
		dynamicStateCount = cast(u32)len(dynamic_states),
		pDynamicStates    = raw_data(dynamic_states),
	}

	vk_assert(vk.CreatePipelineLayout(device, &vk.PipelineLayoutCreateInfo {
		sType                  = .PIPELINE_LAYOUT_CREATE_INFO,
		setLayoutCount         = 1,
		pSetLayouts            = &set_layout,
		pPushConstantRanges    = &vk.PushConstantRange {
			stageFlags = { .VERTEX },
			offset = 0,
			size = cast(u32)size_of([4]f32),
		},
		pushConstantRangeCount = 1,
	}, nil, &pipeline_layout))

	vk_assert(vk.CreateGraphicsPipelines(device, 0, 1, &vk.GraphicsPipelineCreateInfo {
		sType               = .GRAPHICS_PIPELINE_CREATE_INFO,
		stageCount          = cast(u32)len(modules),
		pStages             = raw_data(modules),
		pVertexInputState   = &vertex_input_info,
		pInputAssemblyState = &input_assembly_state,
		pViewportState      = &viewport_state,
		pRasterizationState = &rasterization_state,
		pMultisampleState   = &multisample_state,
		pDepthStencilState  = &depth_stencil,
		pColorBlendState    = &color_blend_state,
		pDynamicState       = &dynamic_state,
		layout              = pipeline_layout,
		renderPass          = info.compatible_renderpass,
	}, nil, &pipeline))
}

cleanup_state :: proc(using vulkan_state: ^Vulkan_State) {
	vk.DestroyPipeline(device, pipeline, nil)
	vk.DestroyPipelineLayout(device, pipeline_layout, nil)

	vk.DestroyImageView(device, font_view, nil)

	vk.DestroySampler(device, font_sampler, nil)
	vk.DestroyImage(device, font_image, nil)
	vk.FreeMemory(device, font_memory, nil)

	vk.DestroyDescriptorPool(device, font_descriptor_pool, nil)
	vk.DestroyDescriptorSetLayout(device, set_layout, nil)

	for frame_data in frame_datas {
		if frame_data.indices.buffer != 0 {
			vk.DestroyBuffer(device, frame_data.indices.buffer, nil)
			vk.FreeMemory(device, frame_data.indices.memory, nil)
		}

		if frame_data.vertices.buffer != 0 {
			vk.DestroyBuffer(device, frame_data.vertices.buffer, nil)
			vk.FreeMemory(device, frame_data.vertices.memory, nil)
		}
	}
}

imgui_render :: proc(command_buffer: vk.CommandBuffer, data: ^imgui.Draw_Data, using vulkan_state: ^Vulkan_State, frame_index: int) {
	fb_width  := data.display_size.x * data.framebuffer_scale.x
	fb_height := data.display_size.y * data.framebuffer_scale.y
	if fb_width <= 0 do return
	if fb_height <= 0 do return
	if data.total_idx_count == 0 || data.total_vtx_count == 0 do return

	vk.CmdBindPipeline(command_buffer, .GRAPHICS, pipeline)
	viewport: [4]f32 = {
		data.display_pos.x,
		data.display_pos.y,
		data.display_size.x,
		data.display_size.y }
	vk.CmdPushConstants(command_buffer, pipeline_layout, { .VERTEX }, 0, size_of(viewport), &viewport)

	vk.CmdSetViewport(command_buffer, 0, 1, &vk.Viewport {
		x = 0, y = 0,
		width = 3840, height = 2160,
		minDepth = 0, maxDepth = 1,
	})

	frame_data := &frame_datas[frame_index]
	ensure_buffer_size(vulkan_state, &frame_data.vertices, vk.DeviceSize(data.total_vtx_count * size_of(imgui.Draw_Vert)), { .VERTEX_BUFFER })
	ensure_buffer_size(vulkan_state, &frame_data.indices, vk.DeviceSize(data.total_idx_count * size_of(imgui.Draw_Idx)), { .INDEX_BUFFER })

	map_buffer(vulkan_state, &frame_data.vertices)
	map_buffer(vulkan_state, &frame_data.indices)

	zero := vk.DeviceSize(0)

	vk.CmdBindVertexBuffers(command_buffer, 0, 1, &frame_data.vertices.buffer, &zero)
	vk.CmdBindIndexBuffer(command_buffer, frame_data.indices.buffer, 0, .UINT16)

	clip_off := data.display_pos
	clip_scale := data.framebuffer_scale

	lists := mem.slice_ptr(data.cmd_lists, int(data.cmd_lists_count))
	for list in lists {
		vtx_offset := write_data_get_offset(vulkan_state, &frame_data.vertices, list.vtx_buffer)
		idx_offset := write_data_get_offset(vulkan_state, &frame_data.indices, list.idx_buffer)

		cmds := mem.slice_ptr(list.cmd_buffer.data, int(list.cmd_buffer.size))
		for cmd, idx in cmds {
			if cmd.user_callback != nil {
				cmd.user_callback(list, &cmds[idx])
			} else {
				// Project scissor/clipping rectangles into framebuffer space
				clip_min := [2]f32 { (cmd.clip_rect.x - clip_off.x) * clip_scale.x, (cmd.clip_rect.y - clip_off.y) * clip_scale.y }
				clip_max := [2]f32 { (cmd.clip_rect.z - clip_off.x) * clip_scale.x, (cmd.clip_rect.w - clip_off.y) * clip_scale.y }

				// Clamp to viewport as vkCmdSetScissor() won't accept values that are off bounds
				if clip_min.x < 0 { clip_min.x = 0 }
				if clip_min.y < 0 { clip_min.y = 0 }
				if clip_max.x > fb_width { clip_max.x = fb_width }
				if clip_max.y > fb_height { clip_max.y = fb_height }

				if clip_max.x <= clip_min.x || clip_max.y <= clip_min.y {
					continue
				}

				vk.CmdSetScissor(command_buffer, 0, 1, &vk.Rect2D {
					offset = { x = i32(clip_min.x), y = i32(clip_min.y) },
					extent = { width = u32(clip_max.x - clip_min.x), height = u32(clip_max.y - clip_min.y) },
				})

				descriptor_set := transmute(vk.DescriptorSet)(cmd.texture_id)
				vk.CmdBindDescriptorSets(command_buffer, .GRAPHICS, pipeline_layout, 0, 1, &descriptor_set, 0, nil)

				vk.CmdDrawIndexed(command_buffer, cmd.elem_count, 1, cast(u32)idx_offset + cmd.idx_offset, cast(i32)vtx_offset + cast(i32)cmd.vtx_offset, 0)
			}
		}
	}

	unmap_buffer(vulkan_state, &frame_data.vertices)
	unmap_buffer(vulkan_state, &frame_data.indices)
}

@(private="package")
create_shader_module :: proc(
	using vulkan_state: ^Vulkan_State,
	shader_data: []u32) -> vk.ShaderModule {

	shader_module: vk.ShaderModule
	vk_assert(vk.CreateShaderModule(device, &vk.ShaderModuleCreateInfo {
		sType    = .SHADER_MODULE_CREATE_INFO,
		codeSize = len(shader_data) * 4, // Vulkan needs the size in bytes
		pCode    = raw_data(shader_data),
	}, nil, &shader_module))

	return shader_module
}

@(private="package")
ensure_buffer_size :: proc(
	using vulkan_state: ^Vulkan_State,
	buffer: ^Vulkan_Buffer,
	data_size: vk.DeviceSize,
	usage_flags: vk.BufferUsageFlags) {

	if data_size <= buffer.size {
		return
	}

	if buffer.buffer != 0 {
		vk.DestroyBuffer(device, buffer.buffer, nil)
		vk.FreeMemory(device, buffer.memory, nil)
	}

	buffer.size = data_size
	buffer.buffer, buffer.memory = create_buffer(vulkan_state, data_size, usage_flags, { .DEVICE_LOCAL, .HOST_COHERENT })
}

@(private="package")
map_buffer :: proc(
	using vulkan_state: ^Vulkan_State,
	buffer: ^Vulkan_Buffer) {

	buffer.offset = 0
	vk.MapMemory(device, buffer.memory, 0, buffer.size, {}, &buffer.ptr)
}

@(private="package")
unmap_buffer :: proc(
	using vulkan_state: ^Vulkan_State,
	buffer: ^Vulkan_Buffer) {

	vk.UnmapMemory(device, buffer.memory)
	buffer.ptr = nil
}

@(private="package")
write_data_get_offset :: proc(
	using vulkan_state: ^Vulkan_State,
	buffer: ^Vulkan_Buffer,
	data: imgui.Im_Vector($T)) -> int {

	data_size := cast(uintptr)(data.size * size_of(T))

	mem.copy(rawptr(uintptr(buffer.ptr) + buffer.offset), data.data, cast(int)data_size)

	old_offset := buffer.offset
	buffer.offset += data_size

	return cast(int)(old_offset / size_of(T))
}

@(private="package")
find_memory_type :: proc(
	using vulkan_state: ^Vulkan_State,
	supported_memory_indices: u32,
	properties: vk.MemoryPropertyFlags) -> u32 {

	for i in 0..<memory_properties.memoryTypeCount {
		if (supported_memory_indices & (1 << i)) == 0 {continue}

		if memory_properties.memoryTypes[i].propertyFlags >= properties {return i}
	}

	log.panicf("Couldn't choose memory type!")
}

@(private="package")
allocate_memory :: proc(
	using vulkan_state: ^Vulkan_State,
	size: vk.DeviceSize,
	memory_requirements: vk.MemoryRequirements,
	properties: vk.MemoryPropertyFlags) -> vk.DeviceMemory {

	memory_info := vk.MemoryAllocateInfo {
		sType           = .MEMORY_ALLOCATE_INFO,
		allocationSize  = size,
		memoryTypeIndex = find_memory_type(vulkan_state, memory_requirements.memoryTypeBits, properties),
	}

	memory: vk.DeviceMemory
	vk_assert(vk.AllocateMemory(device, &memory_info, nil, &memory))

	return memory
}

@(private="package")
allocate_buffer_backing_memory :: proc(
	using vulkan_state: ^Vulkan_State,
	buffer: vk.Buffer,
	properties: vk.MemoryPropertyFlags) -> vk.DeviceMemory {

	memory_requirements: vk.MemoryRequirements
	vk.GetBufferMemoryRequirements(device, buffer, &memory_requirements)

	memory := allocate_memory(vulkan_state, memory_requirements.size, memory_requirements, properties)
	vk_assert(vk.BindBufferMemory(device, buffer, memory, 0))

	return memory
}

@(private="package")
allocate_image_backing_memory :: proc(
	using vulkan_state: ^Vulkan_State,
	image: vk.Image,
	properties: vk.MemoryPropertyFlags) -> vk.DeviceMemory {

	memory_requirements: vk.MemoryRequirements
	vk.GetImageMemoryRequirements(device, image, &memory_requirements)

	memory := allocate_memory(vulkan_state, memory_requirements.size, memory_requirements, properties)
	vk_assert(vk.BindImageMemory(device, image, memory, 0))

	return memory
}

@(private="package")
create_buffer :: proc(
	using vulkan_state: ^Vulkan_State,
	size: vk.DeviceSize,
	usage: vk.BufferUsageFlags,
	properties: vk.MemoryPropertyFlags) -> (buffer: vk.Buffer, memory: vk.DeviceMemory) {

	vk.CreateBuffer(device, &vk.BufferCreateInfo {
		sType       = .BUFFER_CREATE_INFO,
		size        = size,
		usage       = usage,
		sharingMode = .EXCLUSIVE,
	}, nil, &buffer)

	memory = allocate_buffer_backing_memory(vulkan_state, buffer, properties)

	return
}

@(private="package")
image_transition_layout :: proc(
	using vulkan_state: ^Vulkan_State,
	image: vk.Image,
	old_layout, new_layout: vk.ImageLayout) {

	barrier := vk.ImageMemoryBarrier {
		sType = .IMAGE_MEMORY_BARRIER,
		oldLayout = old_layout,
		newLayout = new_layout,
		image = image,
		subresourceRange = {
			aspectMask = {.COLOR},
			baseMipLevel = 0,
			levelCount = 1,
			baseArrayLayer = 0,
			layerCount = 1,
		},
	}

	src_stage, dst_stage: vk.PipelineStageFlags

	if (old_layout == .UNDEFINED && new_layout == .TRANSFER_DST_OPTIMAL) {
		barrier.srcAccessMask = {}
		barrier.dstAccessMask = {.TRANSFER_WRITE}

		src_stage = {.TOP_OF_PIPE}
		dst_stage = {.TRANSFER}
	} else if (old_layout == .TRANSFER_DST_OPTIMAL && new_layout == .SHADER_READ_ONLY_OPTIMAL) {
		barrier.srcAccessMask = {.TRANSFER_WRITE}
		barrier.dstAccessMask = {.SHADER_READ}

		src_stage = {.TRANSFER}
		dst_stage = {.FRAGMENT_SHADER}
	}

	vk.CmdPipelineBarrier(temp_command_buffer, src_stage, dst_stage, {}, 0, nil, 0, nil, 1, &barrier)
}

// imgui.frag
// Compiled with

/*
#version 450

layout(location = 0) in vec2 Frag_UV;
layout(location = 1) in vec4 Frag_Color;

layout(set = 0, binding = 0) uniform sampler2D Texture;

layout (location = 0) out vec4 Out_Color;

void main()
{
    Out_Color = Frag_Color * texture(Texture, Frag_UV.st);
    Out_Color.rgb = pow(Out_Color.rgb, vec3(2.2));
}
*/

