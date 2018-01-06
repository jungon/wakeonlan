//
//  MagicPacket.swift
//  WakeOnLan
//
//  Created by 김중온 on 2016. 2. 8..
//  Copyright © 2016년 김중온. All rights reserved.
//

import Foundation

class MagicPacket {
    
    init(initialIp: String, initialMac: String, initialPort: String) {
        self.ip = initialIp
        self.mac = initialMac
        self.port = initialPort
    }

    var ip: String
    
    var mac: String
    
    var port: String

    var address: in_addr {
        var inaddr: in_addr = in_addr()
        ip.withCString { cs in inet_pton(AF_INET, cs, &inaddr) }
        return inaddr
    }
    
    var magicPacket: [UInt8] {
        return makeMagicPacket(mac)
    }
    
    var cuPort: CUnsignedShort {
        return CUnsignedShort(port)!
    }
    
    func send() {
        udpSend(address, packet: magicPacket, port: cuPort)
    }
    
    func udpSend(address: in_addr, packet: [UInt8], port: CUnsignedShort) {
        let fd = socket(AF_INET, SOCK_DGRAM, 0)
        
        var addr = sockaddr_in(
            sin_len: __uint8_t(sizeof(sockaddr_in)),
            sin_family: sa_family_t(AF_INET),
            sin_port: htons(port),
            sin_addr: address,
            sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
        )
        
        withUnsafePointer(&addr) { sendto(fd, packet, packet.count, 0, UnsafePointer<sockaddr>($0), socklen_t(addr.sin_len)) }
        
        close(fd)
    }
    
    func makeMagicPacket(mac: String) -> [UInt8] {
        var magicPacket = [UInt8](count: 102, repeatedValue: 0xff)
        
        let separated = mac.componentsSeparatedByString(":")
        for index in separated.indices {
            magicPacket[6 + index] = UInt8(separated[index], radix: 16)!
        }
        
        let unit: Int = 6
        let times: Int = 16
        let magicPacketPointer = UnsafeMutablePointer<UInt8>(magicPacket)
        
        for index in 2...times {
            memcpy(magicPacketPointer.advancedBy(unit * index), magicPacketPointer.advancedBy(unit), unit * sizeof(UInt8))
        }
        
        return magicPacket
    }
    
    func htons(value: CUnsignedShort) -> CUnsignedShort {
        return (value << 8) + (value >> 8)
    }
    
}