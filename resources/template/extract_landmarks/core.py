import os
import bpy
import json

# read command line parameters from environment
template = os.getenv('input_file')
output = os.getenv('output_file')


# open template blend file
bpy.ops.wm.open_mainfile(filepath=template)

# build json file with landmark names, coordinates and vertex ids
root = []
ob =  bpy.context.object
group_lookup = {g.index: g.name for g in ob.vertex_groups}
verts = {name: [] for name in group_lookup.values()}
for v in ob.data.vertices:
    for g in v.groups:
        data = {}
        data['name'] = group_lookup[g.group]
        data['index'] = v.index
        data['X'] = v.co.x
        data['Y'] = v.co.y
        data['Z'] = v.co.z
        # only append landmark vertex groups
        if data['name'] != "Ignore":
            root.append(data)

outFile = open(output, 'w')

json.dump(root, outFile, indent=2)

# quit blender
quit()
