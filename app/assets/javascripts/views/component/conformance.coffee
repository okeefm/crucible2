$(window).on('load', ->
  new Crucible.Conformance()
)

class Crucible.Conformance

  constructor: ->
    @element = $('.metadata-expand-container')
    $.ajax({
        type: 'GET',
        url: "#{$(location).attr('pathname')}/conformance_metadata",
        dataType: 'HTML',
        success: ((data) =>
          @updateConformance(data)
          @removeConformanceSpinner()
        ),
        fail: ((data) =>
          @removeConformanceSpinner()
        )
    });

  updateConformance: (data)=>
    console.log(data)
    $("#metadata").replaceWith(data)

  removeConformanceSpinner: =>
    $("#conformance_spinner").remove()
