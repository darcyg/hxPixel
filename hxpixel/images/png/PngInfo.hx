/*
 * Copyright (c) 2013 Heriet [http://heriet.info/].
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package hxpixel.images.png;

enum ColorType {
    GreyScale;
    TrueColor;
    IndexedColor;
    GreyScaleWithAlpha;
    TrueColorWithAlpha;
}

enum CompressionMethod {
    Deflate;
}

enum FilterMethod {
    None;
    Sub;
    Up;
    Average;
    Peath;
}

enum InterlaceMethod {
    None;
    Adam7;
}

class PngInfo
{
    /* Header [IHDR] */
    public var width: Int;
    public var height: Int;
    public var bitDepth: Int;
    public var colotType: ColorType;
    public var compressionMethod: CompressionMethod;
    public var filterMethod: FilterMethod;
    public var interlaceMethod: InterlaceMethod;
    
    /* Bit Depth [sBIT] */
    public var bitRed: Int;
    public var bitGreen: Int;
    public var bitBlue: Int;
    public var bitAlpha: Int;
    public var bitGray: Int;
    
    /* RGB Palette [PLTE] */
    public var palette: Array<Int>;
    
    /* Image [IDAT] */
    public var imageData: Array<Int>;
    
    /* Transparent [tRNS] */
    public var transparent: Int;
    public var paletteTransparent: Array<Int>;
    
    /* Background [bKGD] */
    public var background: Int;
    public var existBackground: Bool;
    
    
    public function new() 
    {
        palette = [];
        imageData = [];
        paletteTransparent = [];
    }
    
    public function getRbgaPalette() : Array<Int>
    {
        var rgbaPalette = new Array<Int>();
        
        var transparentLength = paletteTransparent.length;
        for (i in 0 ... palette.length) {
            rgbaPalette[i] = palette[i];
            
            if (i < transparentLength) {
                rgbaPalette[i] += paletteTransparent[i] << 24;
            } else {
                rgbaPalette[i] += 0xFF << 24;
            }
        }
        
        return rgbaPalette;
    }
    
    public function getRgbaImageData() : Array<Int>
    {
        if (!colotType.equals(IndexedColor)) {
            return imageData;
        }
        
        var rgbaPalette = getRbgaPalette();
        var rgbaImageData = new Array<Int>();
        for (i in 0 ... imageData.length) {
            rgbaImageData[i] = rgbaPalette[imageData[i]];
        }
        
        return rgbaImageData;
    }
    
    public function getPaletteLength() : Int
    {
       if (palette == null) {
           return 0;
       }
       
       return palette.length;
    }
    
}