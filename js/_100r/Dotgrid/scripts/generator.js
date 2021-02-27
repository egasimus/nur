'use strict'

/* global client */

function Generator (layer, style) {
  this.layer = layer
  this.style = style

  function operate (layer, offset, scale, mirror = 0, angle = 0) {
    const l = copy(layer)

    for (const k1 in l) {
      const seg = l[k1]
      for (const k2 in seg.vertices) {
        if (mirror === 1 || mirror === 3) { seg.vertices[k2].x = (client.tool.settings.size.width) - seg.vertices[k2].x }
        if (mirror === 2 || mirror === 3) { seg.vertices[k2].y = (client.tool.settings.size.height) - seg.vertices[k2].y }
        // Offset
        seg.vertices[k2].x += offset.x
        seg.vertices[k2].y += offset.y
        // Rotate
        const center = { x: (client.tool.settings.size.width / 2) + offset.x + (7.5), y: (client.tool.settings.size.height / 2) + offset.y + 30 }
        seg.vertices[k2] = rotatePoint(seg.vertices[k2], center, angle)
        // Scale
        seg.vertices[k2].x *= scale
        seg.vertices[k2].y *= scale
      }
    }
    return l
  }

  this.render = function (prev, segment, mirror = 0) {
    const type = segment.type
    const vertices = segment.vertices
    let html = ''
    let skip = 0

    for (const id in vertices) {
      if (skip > 0) { skip -= 1; continue }

      const vertex = vertices[parseInt(id)]
      const next = vertices[parseInt(id) + 1]
      const afterNext = vertices[parseInt(id) + 2]

      if (parseInt(id) === 0 && !prev) {
        html += `M${vertex.x},${vertex.y} `
      } else if (parseInt(id) === 0 && prev && (prev.x !== vertex.x || prev.y !== vertex.y)) {
        html += `M${vertex.x},${vertex.y} `
      }

      if (type === 'line') {
        html += this._line(vertex)
      } else if (type === 'arc_c') {
        const clock = mirror > 0 && mirror < 3 ? '0,0' : '0,1'
        html += this._arc(vertex, next, clock)
      } else if (type === 'arc_r') {
        const clock = mirror > 0 && mirror < 3 ? '0,1' : '0,0'
        html += this._arc(vertex, next, clock)
      } else if (type === 'arc_c_full') {
        const clock = mirror > 0 ? '1,0' : '1,1'
        html += this._arc(vertex, next, clock)
      } else if (type === 'arc_r_full') {
        const clock = mirror > 0 ? '1,1' : '1,0'
        html += this._arc(vertex, next, clock)
      } else if (type === 'bezier') {
        html += this._bezier(next, afterNext)
        skip = 1
      }
    }

    if (segment.type === 'close') {
      html += 'Z '
    }

    return html
  }

  this._line = function (a) {
    return `L${a.x},${a.y} `
  }

  this._arc = function (a, b, c) {
    if (!a || !b || !c) { return '' }

    const offset = { x: b.x - a.x, y: b.y - a.y }

    if (offset.x === 0 || offset.y === 0) { return this._line(b) }
    return `A${Math.abs(b.x - a.x)},${Math.abs(b.y - a.y)} 0 ${c} ${b.x},${b.y} `
  }

  this._bezier = function (a, b) {
    if (!a || !b) { return '' }
    return `Q${a.x},${a.y} ${b.x},${b.y} `
  }

  this.convert = function (layer, mirror, angle) {
    let s = ''
    let prev = null
    for (const id in layer) {
      const seg = layer[parseInt(id)]
      s += `${this.render(prev, seg, mirror)}`
      prev = seg.vertices ? seg.vertices[seg.vertices.length - 1] : null
    }
    return s
  }

  this.toString = function (offset = { x: 0, y: 0 }, scale = 1, mirror = this.style && this.style.mirror_style ? this.style.mirror_style : 0) {
    let s = this.convert(operate(this.layer, offset, scale))

    if (mirror === 1 || mirror === 2 || mirror === 3) {
      s += this.convert(operate(this.layer, offset, scale, mirror), mirror)
    }

    return s
  }

  function copy (data) { return data ? JSON.parse(JSON.stringify(data)) : [] }
  function rotatePoint (point, origin, angle) { angle = angle * Math.PI / 180.0; return { x: (Math.cos(angle) * (point.x - origin.x) - Math.sin(angle) * (point.y - origin.y) + origin.x).toFixed(1), y: (Math.sin(angle) * (point.x - origin.x) + Math.cos(angle) * (point.y - origin.y) + origin.y).toFixed(1) } }
}
