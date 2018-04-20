vizmap = [

   {selector:"node", css: {
       "text-valign":"center",
       "text-halign":"center",
       "border-color": "black",
       "content": "data(id)",
       "border-width": "3px"
       }},

   {selector:"node:selected", css: {
       "text-valign":"center",
       "text-halign":"center",
       "border-color": "black",
       "content": "data(id)",
       "border-width": "3px",
       "overlay-opacity": 0.5,
       "overlay-color": "red"
       }},

    {selector: 'edge', css: {
        'line-color': 'black',
        'width': "1px",
        'target-arrow-shape': 'triangle',
        'target-arrow-color': 'blue',
        'curve-style': 'bezier'
        }},

    {selector: 'edge:selected', css: {
       "overlay-opacity": 0.2,
       "overlay-color": "red"
        }},


   ];
