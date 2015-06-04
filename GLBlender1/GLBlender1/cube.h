// This is a .h file for the model: cube

// Positions: 8
// Texels: 14
// Normals: 6
// Faces: 12
// Vertices: 36


const int cubeVertices = 36;

const float cubePositions[108] =
{
    1, -1, -1,
    1, -1, 1,
    -1, -1, 1,
    1, -1, -1,
    -1, -1, 1,
    -1, -1, -1,
    1, 1, -0.999999,
    -1, 1, -1,
    -1, 1, 1,
    1, 1, -0.999999,
    -1, 1, 1,
    0.999999, 1, 1,
    1, -1, -1,
    1, 1, -0.999999,
    0.999999, 1, 1,
    1, -1, -1,
    0.999999, 1, 1,
    1, -1, 1,
    1, -1, 1,
    0.999999, 1, 1,
    -1, 1, 1,
    1, -1, 1,
    -1, 1, 1,
    -1, -1, 1,
    -1, -1, 1,
    -1, 1, 1,
    -1, 1, -1,
    -1, -1, 1,
    -1, 1, -1,
    -1, -1, -1,
    1, 1, -0.999999,
    1, -1, -1,
    -1, -1, -1,
    1, 1, -0.999999,
    -1, -1, -1,
    -1, 1, -1,
};

const float cubeTexels[72] =
{
    0.375624, 0.500625,
    0.624375, 0.500624,
    0.624375, 0.749375,
    0.375624, 0.500625,
    0.624375, 0.749375,
    0.375625, 0.749375,
    0.375625, 0.251875,
    0.375624, 0.003126,
    0.624373, 0.003126,
    0.375625, 0.251875,
    0.624373, 0.003126,
    0.624374, 0.251874,
    0.375624, 0.500625,
    0.375625, 0.251875,
    0.624374, 0.251874,
    0.375624, 0.500625,
    0.624374, 0.251874,
    0.624375, 0.500624,
    0.873126, 0.749375,
    0.873126, 0.998126,
    0.624375, 0.998126,
    0.873126, 0.749375,
    0.624375, 0.998126,
    0.624375, 0.749375,
    0.624375, 0.749375,
    0.624375, 0.998126,
    0.375625, 0.998126,
    0.624375, 0.749375,
    0.375625, 0.998126,
    0.375625, 0.749375,
    0.126874, 0.998126,
    0.126874, 0.749375,
    0.375625, 0.749375,
    0.126874, 0.998126,
    0.375625, 0.749375,
    0.375625, 0.998126,
};

const float cubeNormals[108] =
{
    0, -1, 0,
    0, -1, 0,
    0, -1, 0,
    0, -1, 0,
    0, -1, 0,
    0, -1, 0,
    0, 1, 0,
    0, 1, 0,
    0, 1, 0, 
    0, 1, 0, 
    0, 1, 0, 
    0, 1, 0, 
    1, 0, 0, 
    1, 0, 0, 
    1, 0, 0, 
    1, 0, 0, 
    1, 0, 0, 
    1, 0, 0, 
    -0, -0, 1, 
    -0, -0, 1, 
    -0, -0, 1, 
    -0, -0, 1, 
    -0, -0, 1, 
    -0, -0, 1, 
    -1, -0, -0, 
    -1, -0, -0, 
    -1, -0, -0, 
    -1, -0, -0, 
    -1, -0, -0, 
    -1, -0, -0, 
    0, 0, -1, 
    0, 0, -1, 
    0, 0, -1, 
    0, 0, -1, 
    0, 0, -1, 
    0, 0, -1, 
};

