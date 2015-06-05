//
//  ObjParser.h
//  GLBlender1
//
//  Created by Son Nguyen Kim on 04/06/15.
//  Copyright (c) 2015 Son Nguyen Kim. All rights reserved.
//

#ifndef __GLBlender1__ObjParser__
#define __GLBlender1__ObjParser__

#include <stdio.h>


// Model Structure
typedef struct Model
{
    int vertices;
    int positions;
    int texels;
    int normals;
    int faces;
}
Model;

Model getOBJinfo(char* fp);

void extractOBJdata(char* fp, float positions[][3], float texels[][2],
                    float normals[][3], int faces[][9]);

const int cubeMaterials = 6;

const int cubeFirsts[6] =
{
    0,
    6,
    12,
    18,
    24,
    30,
};

const int cubeCounts[6] =
{
    6,
    6,
    6,
    6,
    6,
    6,
};

const float cubeDiffuses[6][3] =
{
    1, 0, 1,
    1, 0, 0,
    0, 0, 0.5,
    0, 0.5, 0.5,
    0, 0, 0,
    0, 0, 0,
};

const float cubeSpeculars[6][3] =
{
    0, 0, 0, 
    0, 0, 0, 
    1, 1, 1, 
    1, 1, 1, 
    0, 1, 0, 
    1, 1, 0, 
};


#endif /* defined(__GLBlender1__ObjParser__) */
