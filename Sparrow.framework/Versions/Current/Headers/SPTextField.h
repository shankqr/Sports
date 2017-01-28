//
//  SPTextField.h
//  Sparrow
//
//  Created by Daniel Sperl on 29.06.09.
//  Copyright 2011-2014 Gamua. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the Simplified BSD License.
//

#import <Foundation/Foundation.h>
#import <Sparrow/SPDisplayObjectContainer.h>
#import <Sparrow/SPMacros.h>

@class SPBitmapFont;
@class SPTexture;

SP_EXTERN NSString *const   SPDefaultFontName;
SP_EXTERN const float       SPDefaultFontSize;
SP_EXTERN const uint        SPDefaultFontColor;

SP_EXTERN const float       SPNativeFontSize;

/** ------------------------------------------------------------------------------------------------

 An SPTextField displays text, either using standard iOS fonts or a custom bitmap font.

 You can set all properties you are used to, like the font name and size, a color, the horizontal
 and vertical alignment, etc. The border property is helpful during development, because it lets
 you see the bounds of the textfield.
 
 There are two types of fonts that can be displayed:
 
 - Standard iOS fonts. This renders the text with standard iOS fonts like Verdana or Arial. Use this
   method if you want to keep it simple, and if the text changes not too often. Simply pass the 
   font name to the corresponding property.
 - Bitmap fonts. If you need speed or fancy font effects, use a bitmap font instead. That is a 
   font that has its glyphs rendered to a texture atlas. To use it, first register the font with
   the method `registerBitmapFont:`, and then pass the font name to the corresponding 
   property of the text field.
    
 For the latter, we recommend one of the following tools; both support Sparrow natively.
 
 - [Glyph Designer](http://glyphdesigner.71squared.com) from 71squared. 
 - [bmGlyph](http://www.bmglyph.com) available in the App Store 
  
 Alternatively, you can use the [Bitmap Font Generator](http://www.angelcode.com/products/bmfont)
 from Angel Code, which is a free tool for Windows. Export the font data as an XML 
 file and the texture as a png with white characters on a transparent background (32 bit). 
 
 Here is a sample with a standard font:
 
	SPTextField *textField = [SPTextField textFieldWithWidth:300 height:100 text:@"Hello world!"];
	textField.hAlign = SPHAlignCenter;
	textField.vAlign = SPVAlignCenter;
	textField.fontSize = 18;
	textField.fontName = @"Georgia-Bold"; 
 
 And now we use a bitmap font:

	// Register the font; the returned font name is the one that is defined in the font XML.
	NSString *fontName = [SPTextField registerBitmapFontFromFile:@"bitmap_font.fnt"]; 
	
	SPTextField *textField = [SPTextField textFieldWithWidth:300 height:100 text:@"Hello world!"];
	textField.fontName = fontName;
 
 Tip: Sparrow comes with a small bitmap font that is great for debug output. Just assign the 
 font name `SPBitmapFontMiniName` to a text field to use it.
 
------------------------------------------------------------------------------------------------- */

@interface SPTextField : SPDisplayObjectContainer

/// --------------------
/// @name Initialization
/// --------------------

/// Initialize a text field with all important font properties. _Designated Initializer_.
- (instancetype)initWithWidth:(float)width height:(float)height text:(NSString *)text fontName:(NSString *)name
           fontSize:(float)size color:(uint)color;

/// Initialize a text field with default settings (Helvetica, 14pt, black).
- (instancetype)initWithWidth:(float)width height:(float)height text:(NSString *)text;

/// Initialize a text field with default settings (Helvetica, 14pt, black) and an empty string.
- (instancetype)initWithWidth:(float)width height:(float)height;

/// Initialize a 128x128 textField (Helvetica, 14pt, black).
- (instancetype)initWithText:(NSString *)text;

/// Factory method.
+ (instancetype)textFieldWithWidth:(float)width height:(float)height text:(NSString *)text
                          fontName:(NSString *)name fontSize:(float)size color:(uint)color;

/// Factory method.
+ (instancetype)textFieldWithWidth:(float)width height:(float)height text:(NSString *)text;

/// Factory method.
+ (instancetype)textFieldWithText:(NSString *)text;

/// -------------
/// @name Methods
/// -------------

/// Makes a bitmap font available at any text field, using texture and name as defined in the file.
///
/// @return The name of the font as defined in the font XML.
+ (NSString *)registerBitmapFont:(SPBitmapFont *)font;

/// Makes a bitmap font available at any text field, using the texture defined in the file
/// and manually providing the font name.
///
/// @return The name of the font that was passed to the method.
+ (NSString *)registerBitmapFont:(SPBitmapFont *)font name:(NSString *)fontName;

/// Makes a bitmap font available at any text field, using texture and name as defined in the file.
/// 
/// @return The name of the font as defined in the font XML. 
+ (NSString *)registerBitmapFontFromFile:(NSString *)path;

/// Makes a bitmap font available at any text field, using a custom texture.
///
/// @return The name of the font as defined in the font XML.
+ (NSString *)registerBitmapFontFromFile:(NSString *)path texture:(SPTexture *)texture;

/// Makes a bitmap font available at any text field, using a custom texture and font name.
///
/// @retrurn The name of the font that was passed to the method.
+ (NSString *)registerBitmapFontFromFile:(NSString *)path texture:(SPTexture *)texture
                                    name:(NSString *)fontName;

/// Unregisters the bitmap font of this name.
+ (void)unregisterBitmapFont:(NSString *)name;

/// Get the bitmap font that was registered under a certain name.
+ (SPBitmapFont *)registeredBitmapFont:(NSString *)name;

/// ----------------
/// @name Properties
/// ----------------

/// The displayed text.
@property (nonatomic, copy) NSString *text;

/// The name of the font.
@property (nonatomic, copy) NSString *fontName;

/// The size of the font. For bitmap fonts, use `SPNativeFontSize` for the original size.
@property (nonatomic, assign) float fontSize;

/// The horizontal alignment of the text.
@property (nonatomic, assign) SPHAlign hAlign;

/// The vertical alignment of the text.
@property (nonatomic, assign) SPVAlign vAlign;

/// Allows displaying a border around the edges of the text field. Useful for visual debugging.
@property (nonatomic, assign) BOOL border;

/// The color of the text.
@property (nonatomic, assign) uint color;

/// The bounds of the actual characters inside the text field.
@property (weak, nonatomic, readonly) SPRectangle *textBounds;

/// Allows using kerning information with a bitmap font (where available). Default is YES.
@property (nonatomic, assign) BOOL kerning;

/// Indicates whether the font size is scaled down so that the complete text fits into the
/// text field. Default is NO.
@property (nonatomic, assign) BOOL autoScale;

@end
