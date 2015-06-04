//
//  ObjParser.cpp
//  GLBlender1
//
//  Created by Son Nguyen Kim on 04/06/15.
//  Copyright (c) 2015 Son Nguyen Kim. All rights reserved.
//

#include "ObjParser.h"
#include <iostream>
#include <fstream>
#include <string>
using namespace std;


Model getOBJinfo(char* fp)
{
    // 2
    Model model = {0};
    
    // 3
    // Open OBJ file
    ifstream inOBJ;
    inOBJ.open(fp);
    if(!inOBJ.good())
    {
        cout << "ERROR OPENING OBJ FILE" << endl;
        exit(1);
    }
    
    // 4
    // Read OBJ file
    while(!inOBJ.eof())
    {
        // 5
        string line;
        getline(inOBJ, line);
        string type = line.substr(0,2);
        
        // 6
        if(type.compare("v ") == 0)
            model.positions++;
        else if(type.compare("vt") == 0)
            model.texels++;
        else if(type.compare("vn") == 0)
            model.normals++;
        else if(type.compare("f ") == 0)
            model.faces++;
    }
    
    // 7
    model.vertices = model.faces*3;
    
    // 8
    // Close OBJ file
    inOBJ.close();
    
    cout << "Model Info" << endl;
    cout << "Positions: " << model.positions << endl;
    cout << "Texels: " << model.texels << endl;
    cout << "Normals: " << model.normals << endl;
    cout << "Faces: " << model.faces << endl;
    cout << "Vertices: " << model.vertices << endl;
    
    // 9
    return model;
}

void extractOBJdata(char* fp, float positions[][3], float texels[][2], float normals[][3], int faces[][9])
{
    // Counters
    int p = 0;
    int t = 0;
    int n = 0;
    int f = 0;
    
    // Open OBJ file
    ifstream inOBJ;
    inOBJ.open(fp);
    if(!inOBJ.good())
    {
        cout << "ERROR OPENING OBJ FILE" << endl;
        exit(1);
    }
    
    // Read OBJ file
    while(!inOBJ.eof())
    {
        string line;
        getline(inOBJ, line);
        string type = line.substr(0,2);
        
        // Positions
        if(type.compare("v ") == 0)
        {
            // 1
            // Copy line for parsing
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            // 2
            // Extract tokens
            strtok(l, " ");
            for(int i=0; i<3; i++)
                positions[p][i] = atof(strtok(NULL, " "));
            
            // 3
            // Wrap up
            delete[] l;
            p++;
        }
        
        // Texels
        else if(type.compare("vt") == 0)
        {
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            strtok(l, " ");
            for(int i=0; i<2; i++)
                texels[t][i] = atof(strtok(NULL, " "));
            
            delete[] l;
            t++;
        }
        
        // Normals
        else if(type.compare("vn") == 0)
        {
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            strtok(l, " ");
            for(int i=0; i<3; i++)
                normals[n][i] = atof(strtok(NULL, " "));
            
            delete[] l;
            n++;
        }
        
        // Faces
        else if(type.compare("f ") == 0)
        {
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            strtok(l, " ");
            for(int i=0; i<9; i++)
                faces[f][i] = atof(strtok(NULL, " /"));
            
            delete[] l;
            f++;
        }    }
    
    // Close OBJ file
    inOBJ.close();
    
    cout << "Model Data" << endl;
    cout << "P1: " << positions[0][0] << "x " << positions[0][1] << "y " << positions[0][2] << "z" << endl;
    cout << "T1: " << texels[0][0] << "u " << texels[0][1] << "v " << endl;
    cout << "N1: " << normals[0][0] << "x " << normals[0][1] << "y " << normals[0][2] << "z" << endl;
    cout << "F1v1: " << faces[0][0] << "p " << faces[0][1] << "t " << faces[0][2] << "n" << endl;
}




