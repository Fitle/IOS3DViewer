//
//  ViewController.m
//  GLBlender1
//
//  Created by Son Nguyen Kim on 03/06/15.
//  Copyright (c) 2015 Son Nguyen Kim. All rights reserved.
//

#import "ViewController.h"
#import "ObjParser.h"
#import "cube.h"

@interface ViewController ()
{
    int nbVertices;
    float verticePositions[108];
    float verticesTexels[72];
    float verticesNormals[108];
    float   _rotate;
}

@property (strong, nonatomic) GLKBaseEffect* effect;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self parseObj];
    
    // Set up context
    EAGLContext* context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    // Create effect
    [self createEffect];
    
    // Set up view
    GLKView* glkview = (GLKView *)self.view;
    glkview.context = context;
    
    // OpenGL ES Settings
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glEnable(GL_CULL_FACE);
}

- (void) parseObj
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"cube.obj" ofType:nil];
    
    Model model = getOBJinfo((char*)[path UTF8String]);
    
    nbVertices = model.vertices;
    
    // Model Data
    float positions[model.positions][3];    // XYZ
    float texels[model.texels][2];          // UV
    float normals[model.normals][3];        // XYZ
    int faces[model.faces][9];              // PTN PTN PTN
    
    extractOBJdata((char*)[path UTF8String], positions, texels, normals, faces);
    
    for(int i=0; i<model.faces; i++)
    {
        // 3
        int vA = faces[i][0] - 1;
        int vB = faces[i][3] - 1;
        int vC = faces[i][6] - 1;
        
        // 4
        verticePositions[9*i] = positions[vA][0] ;
        verticePositions[9*i+1] = positions[vA][1] ;
        verticePositions[9*i+2] = positions[vA][2];
        
        
        verticePositions[9*i+3] =  positions[vB][0] ;
        verticePositions[9*i+4] = positions[vB][1] ;
        verticePositions[9*i+5] = positions[vB][2] ;
        
        verticePositions[9*i+6] =  positions[vC][0] ;
        verticePositions[9*i+7] = positions[vC][1] ;
        verticePositions[9*i+8] = positions[vC][2] ;
    }
    
    for(int i=0; i<model.faces; i++)
    {
        int vtA = faces[i][1] - 1;
        int vtB = faces[i][4] - 1;
        int vtC = faces[i][7] - 1;
        
        verticesTexels[6*i]= texels[vtA][0];
        verticesTexels[6*i+1]= texels[vtA][1];
        
        verticesTexels[6*i+2]= texels[vtB][0];
        verticesTexels[6*i+3]= texels[vtB][1];

        verticesTexels[6*i+4]= texels[vtC][0];
        verticesTexels[6*i+5]= texels[vtC][1];
    }
    
    for(int i=0; i<model.faces; i++)
    {
        int vnA = faces[i][2] - 1;
        int vnB = faces[i][5] - 1;
        int vnC = faces[i][8] - 1;
        
        verticesNormals[9*i] = normals[vnA][0];
        verticesNormals[9*i+1] = normals[vnA][1];
        verticesNormals[9*i+2] = normals[vnA][2];
        
        verticesNormals[9*i+3] = normals[vnB][0];
        verticesNormals[9*i+4] = normals[vnB][1];
        verticesNormals[9*i+5] = normals[vnB][2];
        
        verticesNormals[9*i+6] = normals[vnC][0];
        verticesNormals[9*i+7] = normals[vnC][1];
        verticesNormals[9*i+8] = normals[vnC][2];
    }



    
    NSLog(@"con meo");
}

- (void)createEffect
{
    // Initialize
    self.effect = [[GLKBaseEffect alloc] init];
    
    // Texture
    NSDictionary* options = @{ GLKTextureLoaderOriginBottomLeft: @YES };
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"cube.png" ofType:nil];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    
    if(texture == nil)
        NSLog(@"Error loading file: %@", [error localizedDescription]);
    
    self.effect.texture2d0.name = texture.name;
    self.effect.texture2d0.enabled = true;
    
    // Light
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.position = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    self.effect.lightingType = GLKLightingTypePerPixel;

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Prepare effect
    [self.effect prepareToDraw];
    
    // Set matrices
    [self setMatrices];
    
    // 1
    // Positions
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, verticePositions);
    
    // Texels
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, verticesTexels);
    
    // Normals
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, verticesNormals);
    
    // 2
    // Draw Model
    glDrawArrays(GL_TRIANGLES, 0, nbVertices);
}

- (void)setMatrices
{
    // Projection Matrix
    const GLfloat aspectRatio = (GLfloat)(self.view.bounds.size.width) / (GLfloat)(self.view.bounds.size.height);
    const GLfloat fieldView = GLKMathDegreesToRadians(90.0f);
    const GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1f, 10.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // ModelView Matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, -5.0f);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(45.0f));
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, GLKMathDegreesToRadians(_rotate));
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, GLKMathDegreesToRadians(_rotate));
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)update
{
    _rotate += 1.0f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
