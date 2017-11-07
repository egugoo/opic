t0 = Date.now()
format = d3.timeFormat('%M:%S')

setInterval ->
  t1 = Date.now() - t0
  d3.select('#time').style 'width', t1/900 + '%'
  d3.select('#time').text format t1
, 100

row = (d) ->
  id: d.Id
  day: d.Day
  question: d.Question
  answer: d.Answer

color = d3.scaleOrdinal d3.schemeCategory20
div = d3.select '#questions'
d3.tsv 'data.tsv', row, (err, rows) ->

  card =
    div.selectAll('.card').data(rows).enter()
        .append 'div'
          .attr 'class', 'col-xs-12 col-sm-12 col-md-6 col-lg-4 mb-2'
          .append 'div'
            .classed 'card', true
            .append 'div'
              .classed 'card-body', true

  card.append 'div'
      .attr 'class', 'float-left'
      .call (sel) ->
        sel.append 'span'
          .attr 'class', 'btn btn-link btn-nodeco material-icons'
          .style 'color', (d) -> color d.day
          .text 'lens'
        sel.append 'span'
          .attr 'class', 'card-title'
          .text (d) -> "#{d.id} #{d.day}"

  card.each ->
      sel = d3.select @
      div =
        sel.append 'div'
            .attr 'class', 'btn-group float-right'

      # audio and button
      div.each ->
          sel = d3.select @
          sel.append 'button'
            .attr 'class', 'btn btn-sm btn-light material-icons control mr-1'
            .text 'play_arrow'
            .on 'click', ->
              switch sel.select('.control').text()
                when 'play_arrow'
                  sel.select('audio').node().play()
                when 'stop'
                  sel.select('audio').node().pause()
                  sel.select('audio').node().currentTime = 0
                else
                  sel.select('audio').node().pause()

          sel.append 'audio'
            .on 'play', (d) ->
              sel.select('.control').text 'stop'
              d3.selectAll('.card').classed 'bg-dark text-white', false
              d3.select(sel.node().parentNode.parentNode)
                .classed 'bg-dark text-white', true
            .on 'pause', (d) ->
              sel.select('.control').text 'play_arrow'
              t0 = Date.now()  # reset timer
            .append 'source'
              .attr 'src', (d) -> "questions/#{d.id.toLowerCase()}.mp3"
              .attr 'type', 'audio/mpeg'

      # qa modal
      div.append 'button'
          .attr 'class', 'btn btn-sm btn-light material-icons script'
          .text 'question_answer'
          .on 'click', (d) ->
            d3.select('#qaModal #title').text "#{d.id}-#{d.day}"
            d3.select('#qaModal #question').text d.question
            d3.select('#qaModal #answer').text d.answer
            $('#qaModal').modal 'show'
