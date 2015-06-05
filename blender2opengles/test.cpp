//
//  test.c
//  blender2opengles
//
//  Created by Son Nguyen Kim on 05/06/15.
//  Copyright (c) 2015 Son Nguyen Kim. All rights reserved.
//

#include <stdio.h>
#include<iostream>

using namespace std;

int main(int argc, const char * argv[])
{
    
    int (*p)[10] = new int[5][10];
    p[0][9]= -9;
    p[4][9] = -13;
    
    cout << (*p)[9] << endl;
    cout << (*(p+4))[9] << endl;
    
    printf("con meo\n");
}