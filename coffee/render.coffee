
define (require, exports) ->

  $ = require 'jquery'

  show = (args...) -> console.log.apply console, args

  line = (n) ->
    arr = []
    [1..n].forEach -> arr.push 0
    arr

  square = (n) ->
    arr = []
    [1..n].forEach -> arr.push (line n)
    arr

  handler = (e1) ->
    file = e1.target.files[0]

    reader = new FileReader
    reader.onload = (e2) ->
      url = e2.target.result
      $('#play').attr 'src', url

      image = new Image
      image.src = url

      # show image

      cvs = $('#cvs')[0]
      ctx = cvs.getContext '2d'

      height = $('#play').height()
      width = $('#play').width()

      r_w = 20
      r_h = 20 /  width * height

      $(cvs).attr 'height', (r_h + 1)
      ctx.drawImage image, 0, 0, 20, r_h

      data = ctx.getImageData 0, 0, r_w, r_h

      allx = data.width
      ally = data.height

      show 'data: ', data
      show 'all:', allx, ally

      n = 20

      number = Number $('#number').val()
      unless isNaN number then n = number
      n = 20 if number > 40 or number < 3

      dx = allx / n
      dy = ally / n

      show 'dx, dy: ', dx, dy

      get_point = (x, y) ->
        x = Math.floor x
        y = Math.floor y
        show 'point:', x, y
        index = ((y * allx) + x) * 4
        r = data.data[index]
        g = data.data[index + 1]
        b = data.data[index + 2]
        a = data.data[index + 3]
        show 'data: ', r, g, b, a

        # show r
        # a = data.data[index + 3]
        avarage = (r + g + b) / 3
        # show 'avarage', avarage
        avarage

      show (get_point 120, 120)

      grid = []
      [1..n].forEach (y) ->
        arr = []
        [1..n].forEach (x) ->
          avarage = 0
          s_y = Math.floor (y-1)*dy
          e_y = s_y + dy - 1
          [s_y..e_y].forEach (ay) ->
            s_x = Math.floor (x-1)*dx
            e_x = s_x + dx - 1
            [s_x..e_x].forEach (ax) ->
              # show ay
              avarage += get_point ax, ay
          avarage /= (dx * dy)
          # show avarage
          arr.push avarage

        grid.push arr
        # show arr

      grid.forEach (arr) ->
        show arr.map(Math.floor).join ' '

      html = ''
      grid.forEach (line) ->
        hori = '<div class="line">'
        line.forEach (point) ->
          hori += "<div class='tile' style='background:
            hsl(0,0%,#{point/255*100}%);'></div>"
        hori += '</div>'
        html += hori

      $('#right').empty().append html

    reader.readAsDataURL file

  $('#file').on 'change', handler

  return