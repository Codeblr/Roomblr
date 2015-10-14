//
//  ArraySlice.swift
//  Roomblr
//
//  Created by Jasen Salcido on 10/14/15.
//  Copyright © 2015 tumblr. All rights reserved.
//

import Foundation

extension Array {
    func slice(args: Int...) -> Array {
        var s = args[0]
        var e = self.count - 1
        if args.count > 1 { e = args[1] }
        
        if e < 0 {
            e += self.count
        }
        
        if s < 0 {
            s += self.count
        }
        
        let count = (s < e ? e-s : s-e)+1
        let inc = s < e ? 1 : -1
        var ret = Array()
        
        var idx = s
        for var i=0;i<count;i++  {
            ret.append(self[idx])
            idx += inc
        }
        return ret
    }
}