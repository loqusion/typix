#import "@preview/example:0.1.0": add
#import "@preview/cetz:0.3.4"
#import "@preview/polylux:0.4.0": slide, uncover

// example

2 + 2 = #[add(2 + 2)]

// cetz

#cetz.canvas({
  import cetz.draw: *

  circle((0, 0))
  line((0, 0), (2, 1))
})

// polylux

// Make the paper dimensions fit for a presentation and the text larger
#set page(paper: "presentation-16-9")
#set text(size: 25pt)

// Use #slide to create a slide and style it using your favourite Typst functions
#slide[
  #set align(horizon)
  = Very minimalist slides

  A lazy author

  July 23, 2023
]

#slide[
  == First slide

  Some static text on this slide.
]

#slide[
  == This slide changes!

  You can always see this.
  // Make use of features like #uncover, #only, and others to create dynamic content
  #uncover(2)[But this appears later!]
]
