//
//  NSDataBase64Extension.swift
//  UIEffectDesignerView-Swift
//
//  Created by iosdev on 15/9/21.
//  Copyright © 2015年 iosdev. All rights reserved.
//

import Foundation

//
// Mapping from 6 bit pattern to ASCII character.
//
private let base64EncodeLookup: [CChar] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".cStringUsingEncoding(NSUTF8StringEncoding)!

//"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

//
// Definition for "masked-out" areas of the base64DecodeLookup mapping
//
private let xx: CChar = 65

//
// Mapping from ASCII character to 6 bit pattern.
//
private let base64DecodeLookup: [CChar] = [
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx,
    xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx,
    xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
]

//
// Fundamental sizes of the binary and base64 encode/decode units in bytes
//
private let BinaryUnitSize: size_t = 3
private let Base64UnitSize: size_t = 4

//
// NewBase64Decode
//
// Decodes the base64 ASCII string in the inputBuffer to a newly malloced
// output buffer.
//
//  inputBuffer - the source ASCII string for the decode
//	length - the length of the string or -1 (to specify strlen should be used)
//	outputLength - if not-NULL, on output will contain the decoded length
//
// returns the decoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//
func NewBase64Decode(buffer: UnsafePointer<Void>, var length: size_t, inout outputLength: size_t) -> UnsafePointer<Void> {
    
    let inputBuffer: UnsafePointer<CChar> = UnsafePointer<CChar>(buffer)
    
    if length == -1 {
        length = size_t(strlen(inputBuffer))
    }
    
    let outputBufferSize: size_t = ((length + Base64UnitSize - 1) / Base64UnitSize) * BinaryUnitSize
    let outputBuffer: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.alloc(outputBufferSize)
    
    var i: size_t = 0, j: size_t = 0
    while i < length {
        //
        // Accumulate 4 valid characters (ignore everything else)
        //
        var accumulated: [CChar] = Array(count: Base64UnitSize, repeatedValue: 0)
        var accumulateIndex: size_t = 0
        while i < length {
            let decode: CChar = base64DecodeLookup[Int(inputBuffer[i++])]
            if decode != xx {
                accumulated[accumulateIndex] = decode
                accumulateIndex++
                
                if accumulateIndex == Base64UnitSize {
                    break
                }
            }
        }
        
        //
        // Store the 6 bits from each of the 4 characters as 3 bytes
        //
        // (Uses improved bounds checking suggested by Alexandre Colucci)
        //
        if accumulateIndex >= 2 {
            outputBuffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4)
        }
        if accumulateIndex >= 3 {
            outputBuffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2)
        }
        if accumulateIndex >= 4 {
            outputBuffer[j + 2] = (accumulated[2] << 6) | accumulated[3]
        }
        
        j += accumulateIndex - 1
    }
    
    outputLength = j
    
    return UnsafePointer<Void>(outputBuffer)
}

//
// NewBase64Encode
//
// Encodes the arbitrary data in the inputBuffer as base64 into a newly malloced
// output buffer.
//
//  inputBuffer - the source data for the encode
//	length - the length of the input in bytes
//  separateLines - if zero, no CR/LF characters will be added. Otherwise
//		a CR/LF pair will be added every 64 encoded chars.
//	outputLength - if not-NULL, on output will contain the encoded length
//		(not including terminating 0 char)
//
// returns the encoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//

func NewBase64Encode(buffer: UnsafePointer<Void>, length: size_t, separateLines: Bool, inout outputLength: size_t) -> UnsafePointer<Void> {
    
    let inputBuffer: UnsafePointer<CChar> = UnsafePointer<CChar>(buffer)
    
//    let MAX_NUM_PADDING_CHARS: size_t = 2
    let OUTPUT_LINE_LENGTH: size_t = 64
    let INPUT_LINE_LENGTH: size_t = (OUTPUT_LINE_LENGTH / Base64UnitSize) * BinaryUnitSize
    let CR_LF_SIZE: size_t = 2
    
    //
    // Byte accurate calculation of final buffer size
    //
    var outputBufferSize: size_t = ((length / BinaryUnitSize) + ((length % BinaryUnitSize != 0) ? 1 : 0)) * Base64UnitSize
    if separateLines {
        outputBufferSize += (outputBufferSize / OUTPUT_LINE_LENGTH) * CR_LF_SIZE
    }

    //
    // Include space for a terminating zero
    //
    outputBufferSize += 1

    //
    // Allocate the output buffer
    //
    let outputBuffer: UnsafeMutablePointer<CChar> = UnsafeMutablePointer<CChar>.alloc(outputBufferSize)
    
//    if outputBuffer == nil {
//        return //nil
//    }

    var i: size_t = 0, j: size_t = 0
    let lineLength: size_t = separateLines ? INPUT_LINE_LENGTH : length
    var lineEnd = lineLength
    
    while true {
        if lineEnd > length {
            lineEnd = length
        }

        for i = 0; i + BinaryUnitSize - 1 < lineEnd; i += BinaryUnitSize {
            //
            // Inner loop: turn 48 bytes into 64 base64 characters
            //
            outputBuffer[j++] = base64EncodeLookup[Int((UInt8(inputBuffer[i]) & 0xFC) >> 2)]
            outputBuffer[j++] = base64EncodeLookup[Int(((UInt8(inputBuffer[i + 1]) & 0x0F) << 2)
                | ((UInt8(inputBuffer[i + 2]) & 0xC0) >> 6))]
            outputBuffer[j++] = base64EncodeLookup[Int(((UInt8(inputBuffer[i + 1]) & 0x0F) << 2)
                | ((UInt8(inputBuffer[i + 2]) & 0xC0) >> 6))]
            outputBuffer[j++] = base64EncodeLookup[Int(UInt8(inputBuffer[i + 2]) & 0x3F)]
        }

        if lineEnd == length {
            break
        }
        
        //
        // Add the newline
        //
        outputBuffer[j++] = "\r".cStringUsingEncoding(NSUTF8StringEncoding)[0]
        outputBuffer[j++] = "\n".cStringUsingEncoding(NSUTF8StringEncoding)[0]
        lineEnd += lineLength
    }

    if i + 1 < length {
        //
        // Handle the single '=' case
        //
        outputBuffer[j++] = base64EncodeLookup[Int((UInt8(inputBuffer[i]) & 0xFC) >> 2)]
        outputBuffer[j++] = base64EncodeLookup[Int(((UInt8(inputBuffer[i]) & 0x03) << 4)
            | ((UInt8(inputBuffer[i + 1]) & 0xF0) >> 4))]
        outputBuffer[j++] = base64EncodeLookup[Int((UInt8(inputBuffer[i + 1]) & 0x0F) << 2)]
        outputBuffer[j++] = "=".cStringUsingEncoding(NSUTF8StringEncoding)![0]
    } else if i < length {
        //
        // Handle the double '=' case
        //
        outputBuffer[j++] = base64EncodeLookup[Int((UInt8(inputBuffer[i]) & 0xFC) >> 2)]
        outputBuffer[j++] = base64EncodeLookup[Int((UInt8(inputBuffer[i]) & 0x03) << 4)]
        outputBuffer[j++] = "=".cStringUsingEncoding(NSUTF8StringEncoding)![0]
        outputBuffer[j++] = "=".cStringUsingEncoding(NSUTF8StringEncoding)![0]
    }
    outputBuffer[j] = 0
    
    //
    // Set the output length and return the buffer
    //
    outputLength = j
    
    return UnsafePointer<Void>(outputBuffer)
}

extension NSData {
    
    //
    // dataFromBase64String:
    //
    // Creates an NSData object containing the base64 decoded representation of
    // the base64 string 'aString'
    //
    // Parameters:
    //    aString - the base64 string to decode
    //
    // returns the autoreleased NSData representation of the base64 string
    //
    class func dataFromBase64String(aString: String) -> NSData {
        
        let data: NSData = aString.dataUsingEncoding(NSASCIIStringEncoding)!
        var outputLength: size_t = 0
        let outputBuffer = NewBase64Decode(data.bytes, length: data.length, outputLength: &outputLength)
        let result: NSData = NSData(bytes: outputBuffer, length: outputLength)
        
        return result
    }
    
    //
    // base64EncodedString
    //
    // Creates an NSString object that contains the base 64 encoding of the
    // receiver's data. Lines are broken at 64 characters long.
    //
    // returns an autoreleased NSString being the base 64 representation of the
    //	receiver.
    //
    func base64EncodedString() -> String? {
        var outputLength: size_t = 0
        let outputBuffer: UnsafePointer<Void> = NewBase64Encode(self.bytes, length: self.length, separateLines: true, outputLength: &outputLength)
        
        let result: String? = String(data: NSData(bytes: outputBuffer, length: outputLength), encoding: NSASCIIStringEncoding)
        
        return result
    }
    
    // added by Hiroshi Hashiguchi
    func base64EncodedStringWithSeparateLines(separateLines: Bool) -> String? {
        var outputLength: size_t = 0
        let outputBuffer: UnsafePointer<Void> = NewBase64Encode(self.bytes, length: self.length, separateLines: separateLines, outputLength: &outputLength)
        
        let result: String? = String(data: NSData(bytes: outputBuffer, length: outputLength), encoding: NSASCIIStringEncoding)
        
        return result
    }
}
