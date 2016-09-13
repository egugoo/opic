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
          .attr 'class', 'col-xs-12 col-sm-12 col-md-6 col-lg-4'
          .append 'div'
            .classed 'card', true
            .append 'div'
              .classed 'card-block', true

  card.append 'h4'
      .classed 'card-title', true
      .style 'color', (d) -> color d.day
      .text (d) -> d.id

  # audio and button
  card.each ->
      sel = d3.select @
      sel.append 'button'
        .attr 'class', 'btn btn-link material-icons control'
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
        .on 'play', (d) -> sel.select('.control').text 'stop'
        .on 'pause', (d) -> sel.select('.control').text 'play_arrow'
        .append 'source'
          .attr 'src', (d) -> "questions/#{d.id.toLowerCase()}.mp3"
          .attr 'type', 'audio/mpeg'

  # qa modal
  card.append 'button'
        .attr 'class', 'btn btn-link material-icons'
        .text 'question_answer'
        .on 'click', (d) ->
          d3.select('#qaModal #question').text d.question
          d3.select('#qaModal #answer').text d.answer
          $('#qaModal').modal 'show'

  $('.collapse').collapse('hide')
