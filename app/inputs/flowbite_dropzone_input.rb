class FlowbiteDropzoneInput
  include Formtastic::Inputs::Base

  def to_html
    input_wrapping do
      dropzone_html
    end
  end

  private

  def dropzone_html
    template.content_tag(:div, class: "flex items-center justify-center w-full") do
      template.content_tag(:label, for: input_dom_id, class: "flex flex-col items-center justify-center w-full h-64 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:hover:bg-gray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600") do
        template.content_tag(:div, class: "flex flex-col items-center justify-center pt-5 pb-6") do
          template.content_tag(:svg, class: "w-8 h-8 mb-4 text-gray-500 dark:text-gray-400", "aria-hidden": "true", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 20 16") do
            template.content_tag(:path, nil, stroke: "currentColor", "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2")
          end <<
          template.content_tag(:p, class: "mb-2 text-sm text-gray-500 dark:text-gray-400") do
            template.content_tag(:span, "Click to upload", class: "font-semibold") + " or drag and drop"
          end <<
          template.content_tag(:p, "SVG, PNG, JPG or GIF (MAX. 800x400px)", class: "text-xs text-gray-500 dark:text-gray-400")
        end <<
        builder.file_field(method, input_html_options.merge(
          class: "hidden",
          id: input_dom_id,
          accept: "image/*"
        ))
      end
    end
  end

  def input_dom_id
    "#{object_name}_#{method}".gsub(/\W/, "_")
  end

  def input_html_options
    super.merge(
      class: "hidden",
      id: input_dom_id
    )
  end

  def image_token
    object.method.blob.signed_id(purpose: attachment_method_symbol)
  end

  def attachment_present?
    object.send(method).attached?
  end

  def attachment_method_symbol
    self.method
  end
end


# <div class="flex items-center justify-center w-full">
#     <label for="dropzone-file" class="flex flex-col items-center justify-center w-full h-64 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 dark:hover:bg-gray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600">
#         <div class="flex flex-col items-center justify-center pt-5 pb-6">
#             <svg class="w-8 h-8 mb-4 text-gray-500 dark:text-gray-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
#                 <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"/>
#             </svg>
#             <p class="mb-2 text-sm text-gray-500 dark:text-gray-400"><span class="font-semibold">Click to upload</span> or drag and drop</p>
#             <p class="text-xs text-gray-500 dark:text-gray-400">SVG, PNG, JPG or GIF (MAX. 800x400px)</p>
#         </div>
#         <input id="dropzone-file" type="file" class="hidden" />
#     </label>
# </div>


# <li class="file input optional" id="product_image_input">
#   <label for="product_image" class="label">Image</label>
#   <input id="product_image" type="file" name="product[image]">
# </li>



# <div class="flex items-start gap-2.5">
#    <img class="h-8 w-8 rounded-full" src="/docs/images/people/profile-picture-3.jpg" alt="Jese image" />
#    <div class="flex flex-col gap-2.5">
#       <div class="flex items-center space-x-2 rtl:space-x-reverse">
#          <span class="text-sm font-semibold text-gray-900 dark:text-white">Bonnie Green</span>
#          <span class="text-sm font-normal text-gray-500 dark:text-gray-400">11:46</span>
#       </div>
#       <div class="leading-1.5 flex w-full max-w-[320px] flex-col">
#          <p class="text-sm font-normal text-gray-900 dark:text-white">This is the new office <3</p>
#          <div class="group relative mt-2">
#             <div class="absolute w-full h-full bg-gray-900/50 opacity-0 group-hover:opacity-100 transition-opacity duration-300 rounded-lg flex items-center justify-center">
#                 <button data-tooltip-target="download-image" class="inline-flex items-center justify-center rounded-full h-10 w-10 bg-white/30 hover:bg-white/50 focus:ring-4 focus:outline-none dark:text-white focus:ring-gray-50">
#                     <svg class="w-5 h-5 text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 16 18">
#                         <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 1v11m0 0 4-4m-4 4L4 8m11 4v3a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-3"/>
#                     </svg>
#                 </button>
#                 <div id="download-image" role="tooltip" class="absolute z-10 invisible inline-block px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 bg-gray-900 rounded-lg shadow-xs opacity-0 tooltip dark:bg-gray-700">
#                     Download image
#                     <div class="tooltip-arrow" data-popper-arrow></div>
#                 </div>
#             </div>
#             <img src="/docs/images/blog/image-2.jpg" class="rounded-lg" />
#          </div>
#       </div>
#       <span class="text-sm font-normal text-gray-500 dark:text-gray-400">Delivered</span>
#    </div>
# </div>
