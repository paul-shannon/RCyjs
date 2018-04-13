vizmap = [

   {selector:"node", css: {
       "text-valign":"center",
       "text-halign":"center",
       "background-color": "lightgreen",
       "border-color": "red",
       "content": "data(id)",
       "border-width": "1px"
       }},

   {selector:"node:selected", css: {
       "text-valign":"center",
       "text-halign":"center",
       "border-color": "black",
       "content": "data(id)",
       "border-width": "3px",
       "overlay-opacity": 0.5,
       "overlay-color": "blue"
       }},

    {selector: 'edge', css: {
        'line-color': 'maroon',
        'source-arrow-shape': 'circle',
        'source-arrow-color': 'orange',
        'target-arrow-shape': 'tee',
        'target-arrow-color': 'black',
        'curve-style': 'bezier'
        }},

    {selector: 'edge:selected', css: {
       "overlay-opacity": 0.2,
       "overlay-color": "maroon"
        }},


   ];
