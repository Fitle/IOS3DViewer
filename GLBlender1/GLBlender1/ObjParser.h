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


#endif /* defined(__GLBlender1__ObjParser__) */
