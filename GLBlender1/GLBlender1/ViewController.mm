//
//  ViewController.m
//  GLBlender1
//
//  Created by Son Nguyen Kim on 03/06/15.
//  Copyright (c) 2015 Son Nguyen Kim. All rights reserved.
//

#import "ViewController.h"
#import "ObjParser.h"
#import "Transformations.h"
#import <iostream>


@interface ViewController ()
{
    int nbVertices;
    int nbMaterials;
    float* verticePositions;
    float* verticesTexels;
    float* verticesNormals;
    float* diffuses;                 // RGB
    float* speculars;                // RGB
    int* firsts;	// Starting vertex
    int* counts;	// Number of vertices

    float   _rotate;
}

@property (strong, nonatomic) GLKBaseEffect* effect;
@property (strong, nonatomic) Transformations* transformations;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self parseObj];
    
    // Initialize transformations
    self.transformations = [[Transformations alloc] initWithDepth:5.0f Scale:2.0f Translation:GLKVector2Make(0.0f, 0.0f) Rotation:GLKVector3Make(0.0f, 0.0f, 0.0f)];
    
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
    // Files
    NSString* path = [[NSBundle mainBundle] pathForResource:@"cube.obj" ofType:nil];
    NSString* mtlPath = [[NSBundle mainBundle] pathForResource:@"cube.mtl" ofType:nil];
    
    // Model Info
    Model model = getOBJinfo((char*)[path UTF8String]);
    nbMaterials = getMTLinfo((char*)[mtlPath UTF8String]);
    
    nbVertices = model.vertices;
    
    // Model Data
    float (*positions)[3] = new float[model.positions][3];    // XYZ :
    float (*texels)[2] = new float[model.texels][2];          // UV
    float (*normals)[3]= new float[model.normals][3];        // XYZ
    int (*faces)[10] = new int[model.faces][10];              // PTN PTN PTN M
    
    using namespace std;
    string* materials = new string[nbMaterials];    // Name
    diffuses = new float[nbMaterials*3];                 // RGB
    speculars = new float[nbMaterials*3];                // RGB
    extractMTLdata((char*)[mtlPath UTF8String], materials, diffuses, speculars);
    extractOBJdata((char*)[path UTF8String], positions, texels, normals, faces, materials,
                   nbMaterials);
    
    firsts = new int[nbMaterials]();	// Starting vertex
    counts= new int[nbMaterials]();	// Number of vertices
    
    verticePositions = new float[nbVertices*3];
    verticesNormals = new float[nbVertices*3];
    verticesTexels= new float[nbVertices*2];
    
    // get vertice positions and counts
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
        
        for(int j=0; j<nbMaterials; j++)
        {
            if(faces[i][9] == j)
            {
                counts[j] += 3;
            }
        }

    }
    
    // get vertice texels
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
    
    // get vertice normals
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

    // get firsts
    for(int i=0; i<nbMaterials; i++)
    {
        if(i == 0)
            firsts[i] = 0;
        else
            firsts[i] = firsts[i-1]+counts[i-1];
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
    NSString* path = [[NSBundle mainBundle] pathForResource:@"cube_decal.png" ofType:nil];
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
    
    // Render by parts
    for(int i=0; i<nbMaterials; i++)
    {
        self.effect.material.diffuseColor = GLKVector4Make(diffuses[3*i], diffuses[3*i+1], diffuses[3*i+2], 1.0f);
        self.effect.material.specularColor = GLKVector4Make(speculars[3*i+0], speculars[3*i+1], speculars[3*i+2], 1.0f);

        
        // Prepare effect
        [self.effect prepareToDraw];
        
        // Draw vertices
        glDrawArrays(GL_TRIANGLES, firsts[i], counts[i]);
    }
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
    
    // for avatar
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, 0.0f, 0.0f, -2.0f);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(20));
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, GLKMathDegreesToRadians(45));
    
    modelViewMatrix = GLKMatrix4Multiply([self.transformations getModelViewMatrix], modelViewMatrix);
    
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

#pragma mark - Gestures

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Begin transformations
    [self.transformations start];
}


- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    // Pan (1 Finger)
    if((sender.numberOfTouches == 1) &&
       ((self.transformations.state == S_NEW) || (self.transformations.state == S_TRANSLATION)))
    {
        CGPoint translation = [sender translationInView:sender.view];
        float x = translation.x/sender.view.frame.size.width;
        float y = translation.y/sender.view.frame.size.height;
        [self.transformations translate:GLKVector2Make(x, y) withMultiplier:5.0f];
    }
    
    // Pan (2 Fingers)
    else if((sender.numberOfTouches == 2) &&
            ((self.transformations.state == S_NEW) || (self.transformations.state == S_ROTATION)))
    {
        const float m = GLKMathDegreesToRadians(0.5f);
        CGPoint rotation = [sender translationInView:sender.view];
        [self.transformations rotate:GLKVector3Make(rotation.x, rotation.y, 0.0f) withMultiplier:m];
    }

}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
    // Pinch
    if((self.transformations.state == S_NEW) || (self.transformations.state == S_SCALE))
    {
        float scale = [sender scale];
        [self.transformations scale:scale];
    }
}
- (IBAction)rotation:(UIRotationGestureRecognizer *)sender {
    // Rotation
    if((self.transformations.state == S_NEW) || (self.transformations.state == S_ROTATION))
    {
        float rotation = [sender rotation];
        [self.transformations rotate:GLKVector3Make(0.0f, 0.0f, rotation) withMultiplier:1.0f];
    }
}

@end
