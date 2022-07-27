/// @description Draw the 3D world

// 3D projections require a view and projection matrix
var camera = camera_get_active();

var xfrom = Player.x;
var yfrom = Player.y;
var zfrom = Player.z;
var xto = xfrom + dcos(Player.look_dir) * dcos(Player.look_pitch);
var yto = yfrom - dsin(Player.look_dir) * dcos(Player.look_pitch);
var zto = zfrom - dsin(Player.look_pitch);

camera_set_view_mat(camera, matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1));
camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000));
camera_apply(camera);

// Everything must be drawn after the 3D projection has been set
gpu_set_zwriteenable(false);
matrix_set(matrix_world, matrix_build(xfrom, yfrom, zfrom, 0, 0, 0, 1, 1, 1));
vertex_submit(skybox, pr_trianglelist, sprite_get_texture(spr_skybox, 0));
matrix_set(matrix_world, matrix_build_identity());
gpu_set_zwriteenable(true);

vertex_submit(vbuffer, pr_trianglelist, sprite_get_texture(spr_grass, 0));

gpu_set_alphatestenable(true);
gpu_set_alphatestref(10);

shader_set(shd_test);

array_sort(object_positions, function(a, b) {
    var dist_a = point_distance(Player.x, Player.y, a.x, a.y);
    var dist_b = point_distance(Player.x, Player.y, b.x, b.y);
    return dist_b - dist_a;
});

for (var i = 0; i < array_length(object_positions); i++) {
    matrix_set(matrix_world, matrix_build(object_positions[i].x, object_positions[i].y, 0, 0, 0, 0, 1, 1, 1));
    //vertex_submit(tree, pr_trianglelist, sprite_get_texture(spr_tree, 0));
    vertex_submit(glass_block, pr_trianglelist, -1);
    matrix_set(matrix_world, matrix_build_identity());
}

shader_reset();