$(window).on('load', -> 
  new Crucible.TestExecutor()
)

class Crucible.TestExecutor
  tests: []

  constructor: ->
    @element = $('.test-executor')
    @element.find('.execute').click(@execute)
    $.getJSON("api/tests.json").success((data) => 
      @tests = data['tests']
      @renderSuites()
    )

  renderSuites: =>
    suitesElement = @element.find('.test-suites')
    suitesElement.empty()
    $(@tests).each (i, test) =>
      html = HandlebarsTemplates['views/templates/servers/test_select']({test: test})
      suitesElement.append(html)

  execute: =>
    tests = $($.map(@element.find(':checked'), (e) -> e.name))
    progress = $("##{this.element.data('progress')}")
    progress.parent().collapse('show')
    progress.find('.progress-bar').css('width',"2%")
    tests.each (i, test) =>
      testElement = @element.find("#test-#{test}")
      testElement.find('.test-status').removeClass('hidden')
      @element.queue("executionQueue", =>
        console.log(test)
        $.ajax({
          type: 'POST',
          url: "#{$(location).attr('pathname')}/tests/#{test}/execute",
          success: ((data) =>
            progress.find('.progress-bar').css('width',"#{(i+1)/tests.length*100}%")
            if i < tests.length-1
              setTimeout((=> @element.dequeue("executionQueue")), 1)
            else
              progress.parent().hide()
            )
        });
      )
    @element.dequeue("executionQueue")
    
