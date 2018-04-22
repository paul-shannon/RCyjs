vizmap = [

    {selector: "node", css: {
        "width": "mapData(flux, 0, 1000, 20, 100)",
        "height": "mapData(flux, 0, 1000, 20, 100)",
        "shape": "ellipse",
        "text-halign": "center",
        "text-valign": "center",
        "background-color": "lightblue",
        "color": "black",
        "font-size": 12,
        "border-width": 1,
        "border-color": "lightgray",
        "content": "data(id)"
        }},

   {selector:"node[type='ligand']", css: {
       "shape": "diamond",
       "background-color": "mapData(flux, 0, 1000, white, red)",
       }},

   {selector:"node[type='receptor']", css: {
       "shape": "roundrectangle",
       "background-color":"mapData(flux, 0, 1000, white, darkgreen)",
       }},


    {selector: "edge", css: {
       "line-color": "black",
        "width": 1,
        "line-style": "solid",
        "font-size": 0,
        "target-arrow-color": "black",
        "target-arrow-shape": "triangle",
        "source-arrow-color": "black",
        "source-arrow-shape": "none",
        "opacity": 1,
        "curve-style": "bezier"}},

    {selector:"node:selected", css: {
       "overlay-opacity": 0.2,
       }},

    {selector: 'edge:selected', css: {
       "overlay-opacity": 0.2,
        }},

   ];
