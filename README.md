### Animation project
I have used three animation controllers to create 3 different animations.
- `_fadeInController` helps with Fade-in of the image.
- `_textGrowController` is used to enlarge the text on the image after the image loads in.
- `_boxGrowController` grows the whole container including image and text to 1.25x of the size.

Image fade in animation is implemented using the built in `FadeTransition` widget.
The text and box enlarge animations are implemented using `ScaleTransition` widgets using custom curves and scales.
The state variable `currentState` helps in starting and resetting the animations.

One of the expected outcomes was to make the transitions happen one after another: _First image fades in, text shows after that and lastly the container enlarges_.

This is implemented by adding a custom listener to each controller and triggerring text and box animations after the fade animation is complete.
