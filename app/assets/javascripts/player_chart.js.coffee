ready = ->
  if $('#player-chart').get(0)?
    data = {
      labels: ["January", "February", "March", "April", "May", "June", "July"]
      datasets: [
        {
          label: "My First dataset"
          fillColor: "rgba(220,220,220,0.2)"
          strokeColor: "rgba(220,220,220,1)"
          pointColor: "rgba(220,220,220,1)"
          pointStrokeColor: "#fff"
          pointHighlightFill: "#fff"
          pointHighlightStroke: "rgba(220,220,220,1)"
          data: [65, 59, 80, 81, 56, 55, 40]
        }
      ]
    }

    options = {
        scaleShowGridLines : true,
        scaleGridLineColor : "rgba(0,0,0,.05)",
        scaleGridLineWidth : 1,
        bezierCurve : true,
        bezierCurveTension : 0.4,
        pointDot : true,
        pointDotRadius : 4,
        pointDotStrokeWidth : 1,
        pointHitDetectionRadius : 20,
        datasetStroke : true,
        datasetStrokeWidth : 2,
        datasetFill : true,
    }

    context     = $('#player-chart').get(0).getContext('2d')
    playerChart = new Chart(context).Line(data, options)

$(document).ready(ready)
$(document).on('page:load', ready)
