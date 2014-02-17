$(function() {
  $.get('/fields', function(data) {
    var list = $('<div/>');
    for (var i in data) {
      var label = $('<label/>');
      var field = $('<input/>')
      field.attr('name', 'fields[]');
      field.val(data[i]);
      field.attr('type', 'checkbox');

      list.append(label);
      label.append(field);
      label.append(data[i]);
      list.append("<br/>");
    }
    $("#topics").html(list);
  });

  $("#filter_form input#json").on('click', function() {
    window.location.href = "/filter.json?" + $("#filter_form").serialize();
  });

  $("#filter_form input#csv").on('click', function() {
    window.location.href = "/filter.csv?" + $("#filter_form").serialize();
  });

  $("#filter_form").on('submit', function(e) {
    e.preventDefault();
    $.getJSON($(this).attr('action'), $(this).serialize(),
      function(data) {
        var table = $("#preview");
        table.html('');
        for (var i in data) {
          var tr = $("<tr/>");
          var item = data[i];
          for (var k in item) {
            if (k == 'photo') {
              var img = $('<td><img src="' + item[k] + '" height="64"></td>');
              tr.append(img);
            } else {
              var elm = $("<td>" + item[k] + "</td>");
              tr.append(elm);
            }
          }
          table.append(tr);
        }
      });
    return true;
  });
});

