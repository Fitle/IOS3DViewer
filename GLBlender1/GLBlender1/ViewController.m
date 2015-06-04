//
//  ViewController.m
//  GLBlender1
//
//  Created by Son Nguyen Kim on 03/06/15.
//  Copyright (c) 2015 Son Nguyen Kim. All rights reserved.
//

#import "ViewController.h"
#import "cube.h"

@interface ViewController ()
{
}

@property (strong, nonatomic) GLKBaseEffect* effect;

@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (void)createEffect
{
    // Initialize
    self.effect = [[GLKBaseEffect alloc] init];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    NSLog(@"drawInRect");
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Prepare effect
    [self.effect prepareToDraw];
    
    // Set matrices
    [self setMatrices];
    
    // 1
    // Positions
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, cubePositions);
    
    // 2
    // Draw Model
    glDrawArrays(GL_TRIANGLES, 0, cubeVertices);
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
    self.effect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
