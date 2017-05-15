class Dashing.Sparklinemood extends Dashing.Widget

  @accessor 'current', ->
    if @get('points')
      points = @get('points')
      points[points.length - 1].y
    else
      ""
  @accessor 'last', ->
    if @get('points')
      points = @get('points')
      points[points.length - 2].y
    else
      ""

  @accessor 'difference', ->
    if @get('points')
      points = @get('points')
      current = parseInt(points[points.length - 1].y)
      last = parseInt(points[points.length - 2].y)
      if last != 0
        diff = Math.abs(Math.round((current - last) / last * 100))
        "#{diff}%"
      else
        "100%"
    else
      ""

  @accessor 'arrow', ->
    if @get('points')
      points = @get('points')
      current = parseInt(points[points.length - 1].y)
      last = parseInt(points[points.length - 2].y)
      if current >= last then 'icon-arrow-up' else 'icon-arrow-down'

  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data('sizex')) + Dashing.widget_margins[0] * 2 * (container.data('sizex') - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data('sizey'))

    # Make the sparkline graph 1/5 of the widget's height
    height /= 5

    $graph = $("<div class='sparkline-container' style='height:#{height}px;'></div>")
    $(@node).append $graph

    @graph = new Rickshaw.Graph(
      element: $graph.get(0)
      width: width
      height: height
      renderer: @get('graphtype')
      series: [{
        color: '#fff',
        data: [{x:0, y:0}]
      }]
    )

    if @get('points')
      @graph.series[0].data = @get('points')
      @graph.render()

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
    moodcss = switch
        when data.level == 1 then "#8c3b5b"
        when data.level == 2 then "#ff7a23"
        when data.level == 3 then "#f1c40f"
        when data.level == 4 then "#5c91df"
        when data.level == 5 then "#1abc9c"
    $(@node).css("background-color", moodcss)
    if @graph && data.points
      @graph.series[0].data = data.points
      @graph.render()
