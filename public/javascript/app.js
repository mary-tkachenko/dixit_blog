window.addEventListener('load', () => {
    loadOriginalPosition();
    attachToggle();
});

// function that loads original position of the image(visual)
function loadOriginalPosition() {
    $('.visual').each(function() {
        const $element = $(this);
        const id = $(this).data('id');
        const top = $element.data('load-visual-x');
        const left = $element.data('load-visual-y');
        $element.offset({ top, left });
        // Ensure order.
        $element.css('z-index', id);
    });
}

// function that adds toggle (from Semantic UI) which helps to controll edit mode
function attachToggle() {
    $('#edit_blog').checkbox({
        onChecked: editOn,
        onUnchecked: editOff,
    });
}

// function when toggle is in on edit mode
function editOn() {
    console.log('Edit on');

    // Disable click on links.
    $('.visual a').click(function(event){
        event.preventDefault();
    });

    // Enable dragging.
    interact('.visual')
    .draggable({
        onmove: dragMoveListener,
        onend: function(event) {
            saveCoordinates(event.target);
        },
    });
}

// function when toggle is in off edit mode
function editOff() {
    console.log('Edit off');

    // Enable link clicks.
    $('.visual a').unbind('click')

    // Disable dragging.
    interact('.visual').draggable(false);
}

// function to save coordinates and to send them via axios to the database
function saveCoordinates(element) {
    // to axis
    $element = $(element);

    const id = $element.data('id');

    const params = new URLSearchParams();
    params.append('visual_x_position', $element.offset().top);
    params.append('visual_y_position', $element.offset().left);

    axios.put(`/dixit/posts/${id}/update-coordinates`, params)
      .then(function (response) {
        console.log(response);
      })
      .catch(function (error) {
        console.log(error);
      });
    
    console.log(params);
}

// function when to actually get position (from Interact js library)
function dragMoveListener(event) {
    const target = event.target;

    // keep the dragged position in the data-x/data-y attributes
    const x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx;
    const y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy;

    // translate the element
    target.style.webkitTransform =
    target.style.transform =
      'translate(' + x + 'px, ' + y + 'px)';

    // update the posiion attributes
    target.setAttribute('data-x', x);
    target.setAttribute('data-y', y);
}


