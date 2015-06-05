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

int getMTLinfo(char* fp)
{
    int m = 0;
    
    // Open MTL file
    ifstream inMTL;
    inMTL.open(fp);
    if(!inMTL.good())
    {
        cout << "ERROR OPENING MTL FILE" << endl;
        exit(1);
    }
    
    // Read MTL file
    while(!inMTL.eof())
    {
        string line;
        getline(inMTL, line);
        string type = line.substr(0,2);
        
        if(type.compare("ne") == 0)
            m++;
    }
    
    // Close MTL file
    inMTL.close();
    
    return m;
}



void extractOBJdata(char* fp, float positions[][3], float texels[][2], float normals[][3], int faces[][10], string* materials, int m)
{
    // Counters
    int p = 0;
    int t = 0;
    int n = 0;
    int f = 0;
    
    // Index
    int mtl = 0;
    
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
        
        // Material
        if(type.compare("us") == 0)
        {
            // Extract token
            string l = "usemtl ";
            string material = line.substr(l.size());
            
            for(int i=0; i<m; i++)
            {
                if(material.compare(materials[i]) == 0)
                    mtl = i;
            }
        }
        
        // Positions
        if(type.compare("v ") == 0)
        {
            // Copy line for parsing
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            // Extract tokens
            strtok(l, " ");
            for(int i=0; i<3; i++)
                positions[p][i] = atof(strtok(NULL, " "));
            
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
            
            // Append material
            faces[f][9] = mtl;
            
            delete[] l;
            f++;
        }
    }
    
    // Close OBJ file
    inOBJ.close();

}

void extractMTLdata(char* fp, string* materials, float diffuses[], float speculars[])
{
    // Counters
    int m = 0;
    int d = 0;
    int s = 0;
    
    // Open MTL file
    ifstream inMTL;
    inMTL.open(fp);
    if(!inMTL.good())
    {
        cout << "ERROR OPENING MTL FILE" << endl;
        exit(1);
    }
    
    // Read MTL file
    while(!inMTL.eof())
    {
        string line;
        getline(inMTL, line);
        string type = line.substr(0,2);
        
        // Names
        if(type.compare("ne") == 0)
        {
            // Extract token
            string l = "newmtl ";
            materials[m] = line.substr(l.size());
            m++;
        }
        
        // Diffuses
        else if(type.compare("Kd") == 0)
        {
            // Copy line for parsing
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            // Extract tokens
            strtok(l, " ");
            for(int i=0; i<3; i++)
                diffuses[3*d+i] = atof(strtok(NULL, " "));
            
            // Wrap up
            delete[] l;
            d++;
        }
        
        // Speculars
        else if(type.compare("Ks") == 0)
        {
            char* l = new char[line.size()+1];
            memcpy(l, line.c_str(), line.size()+1);
            
            strtok(l, " ");
            for(int i=0; i<3; i++)
                speculars[3*s+i] = atof(strtok(NULL, " "));
            
            delete[] l;
            s++;
        }
    }
    
    // Close MTL file
    inMTL.close();
}





