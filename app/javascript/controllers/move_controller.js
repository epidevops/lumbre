import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { patch } from "@rails/request.js"

// Connects to data-controller="move"
//
// Example Usage:
//
// 1. Simple List (Basic drag and drop)
// <div data-controller="move">
//   <div>Item 1</div>
//   <div>Item 2</div>
//   <div>Item 3</div>
// </div>
//
// 2. Shared Lists (Drag between lists)
// <div data-controller="move" data-move-group-value="shared">
//   <div>Item 1</div>
//   <div>Item 2</div>
// </div>
// <div data-controller="move" data-move-group-value="shared">
//   <div>Item 3</div>
//   <div>Item 4</div>
// </div>
//
// 3. Cloning (Items are cloned when dragged)
// <div data-controller="move"
//      data-move-group-value="shared"
//      data-move-pull-value="clone">
//   <div>Item 1</div>
//   <div>Item 2</div>
// </div>
// <div data-controller="move"
//      data-move-group-value="shared">
//   <div>Item 3</div>
//   <div>Item 4</div>
// </div>
//
// 4. Disabled Sorting (Can't reorder, only drag out)
// <div data-controller="move"
//      data-move-sort-value="false">
//   <div>Item 1</div>
//   <div>Item 2</div>
// </div>
//
// 5. Handle-based (Only drag by handle)
// <div data-controller="move"
//      data-move-handle-value=".handle">
//   <div>
//     <span class="handle">☰</span>
//     <span>Item 1</span>
//   </div>
//   <div>
//     <span class="handle">☰</span>
//     <span>Item 2</span>
//   </div>
// </div>
//
// 6. Filtered (Some items can't be dragged)
// <div data-controller="move"
//      data-move-filter-value=".filtered">
//   <div>Item 1</div>
//   <div class="filtered">Item 2 (not draggable)</div>
//   <div>Item 3</div>
// </div>
//
// 7. MultiDrag (Select and drag multiple items)
// <div data-controller="move"
//      data-move-multi-drag-value="true">
//   <div>Item 1</div>
//   <div>Item 2</div>
//   <div>Item 3</div>
// </div>
//
// 8. Swap (Items swap instead of reordering)
// <div data-controller="move"
//      data-move-swap-value="true">
//   <div>Item 1</div>
//   <div>Item 2</div>
//   <div>Item 3</div>
// </div>
//
// 9. Nested Sortables (Sortable within sortable)
// <div data-controller="move"
//      data-move-fallback-on-body-value="true"
//      data-move-swap-threshold-value="0.65">
//   <div>Parent Item 1
//     <div data-controller="move"
//          data-move-fallback-on-body-value="true"
//          data-move-swap-threshold-value="0.65">
//       <div>Child Item 1</div>
//       <div>Child Item 2</div>
//     </div>
//   </div>
//   <div>Parent Item 2</div>
// </div>
//
// 10. Custom Animation and Ghost Class
// <div data-controller="move"
//      data-move-animation-value="200"
//      data-move-ghost-class-value="bg-gray-200">
//   <div>Item 1</div>
//   <div>Item 2</div>
// </div>

export default class extends Controller {
  static values = {
    group: { type: String, default: "" },
    animation: { type: Number, default: 150 },
    ghostClass: { type: String, default: "bg-blue-100" },
    handle: { type: String, default: "" },
    filter: { type: String, default: "" },
    sort: { type: Boolean, default: true },
    pull: { type: String, default: "" },
    put: { type: Boolean, default: true },
    swapThreshold: { type: Number, default: 1 },
    invertSwap: { type: Boolean, default: false },
    fallbackOnBody: { type: Boolean, default: false },
    multiDrag: { type: Boolean, default: false },
    selectedClass: { type: String, default: "selected" },
    fallbackTolerance: { type: Number, default: 3 },
    swap: { type: Boolean, default: false },
    swapClass: { type: String, default: "highlight" },
    url: { type: String, default: "" }
  }

  connect() {
    const options = {
      animation: this.animationValue,
      ghostClass: this.ghostClassValue,
      sort: this.sortValue,
      swapThreshold: this.swapThresholdValue,
      invertSwap: this.invertSwapValue,
      fallbackOnBody: this.fallbackOnBodyValue,
      // Event Handlers
      // onStart: this.start.bind(this),
      onEnd: this.end.bind(this),
      // onUpdate: this.update.bind(this),
      // onSort: this.sort.bind(this),
      // onAdd: this.add.bind(this),
      // onRemove: this.remove.bind(this),
      // onChoose: this.choose.bind(this),
      // onUnchoose: this.unchoose.bind(this),
      // onFilter: this.filter.bind(this),
      // onMove: this.move.bind(this)
      url: this.urlValue
    }

    // Add group configuration if specified
    if (this.groupValue) {
      options.group = {
        name: this.groupValue,
        pull: this.pullValue || true,
        put: this.putValue
      }
    }

    // Add handle if specified
    if (this.handleValue) {
      options.handle = this.handleValue
    }

    // Add filter if specified
    if (this.filterValue) {
      options.filter = this.filterValue
    }

    // Add multi-drag options if enabled
    if (this.multiDragValue) {
      options.multiDrag = true
      options.selectedClass = this.selectedClassValue
      options.fallbackTolerance = this.fallbackToleranceValue
    }

    // Add swap options if enabled
    if (this.swapValue) {
      options.swap = true
      options.swapClass = this.swapClassValue
    }

    this.sortable = new Sortable(this.element, options)
  }

  // Event Handlers
  start(event) {
    console.log('Sortable Start Event:', {
      item: event.item,
      from: event.from,
      oldIndex: event.oldIndex
    })
  }

  async end(event) {
    const id = event.item.dataset.id
    if (!id) {
      console.error("No ID found on dragged item")
      return
    }

    const data = new FormData()
    // Use newIndex + 1 since positions typically start at 1
    data.append("position", event.newIndex + 1)

    // Get category from the item being moved
    const category = event.item.dataset.category
    if (category) {
      data.append("category", category)
    }

    const url = this.urlValue.replace(":id", id)
    if (!url) {
      console.error("No URL template found")
      return
    }

    const response = await patch(url, {
      body: data,
      responseKind: "json"
    })

    if (!response.ok) {
      console.error("Failed to update position:", response.status)
      // Revert the sort if the update failed
      event.item.style.transform = ""
      event.item.style.transition = "transform 0.2s"
      setTimeout(() => {
        event.item.style.transform = "none"
      }, 0)
      return
    }

    // Update all position numbers in the UI
    const result = await response.json
    result.positions.forEach(({ id, position }) => {
      const element = this.element.querySelector(`[data-id="${id}"]`)
      if (element) {
        const positionCell = element.querySelector('td:nth-child(2)') // Assuming position is in the second column
        if (positionCell) {
          positionCell.textContent = position
        }
      }
    })
  }

  update(event) {
    console.log('Sortable Update Event:', {
      item: event.item,
      from: event.from,
      oldIndex: event.oldIndex,
      newIndex: event.newIndex
    })
  }

  sort(event) {
    console.log('Sortable Sort Event:', {
      item: event.item,
      from: event.from,
      oldIndex: event.oldIndex,
      newIndex: event.newIndex
    })
  }

  add(event) {
    console.log('Sortable Add Event:', {
      item: event.item,
      from: event.from,
      to: event.to,
      oldIndex: event.oldIndex,
      newIndex: event.newIndex
    })
  }

  remove(event) {
    console.log('Sortable Remove Event:', {
      item: event.item,
      from: event.from,
      to: event.to,
      oldIndex: event.oldIndex,
      newIndex: event.newIndex
    })
  }

  choose(event) {
    console.log('Sortable Choose Event:', {
      item: event.item,
      from: event.from,
      oldIndex: event.oldIndex
    })
  }

  unchoose(event) {
    console.log('Sortable Unchoose Event:', {
      item: event.item,
      from: event.from,
      oldIndex: event.oldIndex
    })
  }

  filter(event) {
    console.log('Sortable Filter Event:', {
      item: event.item,
      from: event.from,
      oldIndex: event.oldIndex
    })
  }

  move(event) {
    console.log('Sortable Move Event:', {
      item: event.item,
      from: event.from,
      to: event.to,
      oldIndex: event.oldIndex,
      newIndex: event.newIndex
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
    }
  }
}


// new Sortable(example1, {
//   animation: 150,
//   ghostClass: 'blue-background-class'
// });

// // Shared lists
// new Sortable(example2Left, {
//   group: 'shared', // set both lists to same group
//   animation: 150
// });

// new Sortable(example2Right, {
//   group: 'shared',
//   animation: 150
// });

// // Cloning
// // Try dragging from one list to another. The item you drag will be cloned and the clone will stay in the original list.
// new Sortable(example3Left, {
//   group: {
//       name: 'shared',
//       pull: 'clone' // To clone: set pull to 'clone'
//   },
//   animation: 150
// });

// new Sortable(example3Right, {
//   group: {
//       name: 'shared',
//       pull: 'clone'
//   },
//   animation: 150
// });

// Disabling Sorting
// Try sorting the list on the left. It is not possible because it has it's sort option set to false. However, you can still drag from the list on the left to the list on the right.
// new Sortable(example4Left, {
//   group: {
//       name: 'shared',
//       pull: 'clone',
//       put: false // Do not allow items to be put into this list
//   },
//   animation: 150,
//   sort: false // To disable sorting: set sort to false
// });

// new Sortable(example4Right, {
//   group: 'shared',
//   animation: 150
// });

// Handle
// new Sortable(example5, {
//   handle: '.handle', // handle's class
//   animation: 150
// });


// // Filter
// // Try dragging the item with a red background. It cannot be done, because that item is filtered out using the filter option.

// new Sortable(example6, {
//   filter: '.filtered', // 'filtered' class is not draggable
//   animation: 150
// });

// // Thresholds
// // Try modifying the inputs below to affect the swap thresholds. You can see the swap zones of the squares colored in dark blue, while the "dead zones" (that do not cause a swap) are colored in light blue.
// new Sortable(example7, {
//   swapThreshold: 0.29,
//   invertSwap: true,
//   animation: 150
// });


// // Nested Sortables Example
// // NOTE: When using nested Sortables with animation, it is recommended that the fallbackOnBody option is set to true.
// // It is also always recommended that either the invertSwap option is set to true, or the swapThreshold option is lower than the default value of 1 (eg 0.65).
// // Loop through each nested sortable element
// for (var i = 0; i < nestedSortables.length; i++) {
// 	new Sortable(nestedSortables[i], {
// 		group: 'nested',
// 		animation: 150,
// 		fallbackOnBody: true,
// 		swapThreshold: 0.65
// 	});
// }

// // MultiDrag
// // The MultiDrag plugin allows for multiple items to be dragged at a time. You can click to "select" multiple items, and then drag them as one item
// new Sortable(multiDragDemo, {
// 	multiDrag: true, // Enable multi-drag
// 	selectedClass: 'selected', // The class applied to the selected items
// 	fallbackTolerance: 3, // So that we can select items on mobile
// 	animation: 150
// });

// // Swap
// // The Swap plugin changes the behaviour of Sortable to allow for items to be swapped with eachother rather than sorted.

// new Sortable(swapDemo, {
// 	swap: true, // Enable swap plugin
// 	swapClass: 'highlight', // The class applied to the hovered swap item
// 	animation: 150
// });