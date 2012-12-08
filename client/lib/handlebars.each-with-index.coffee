# {{#each_with_index records}}
# 	<li class="legend_item{{index}}"><span></span>{{Name}}</li>
# {{/each_with_index}}

Handlebars.registerHelper 'each_with_index', (array, fn) ->
  buffer = ''
  for i in array
    item = i
    item.index = _i
    buffer += fn(item)
  buffer