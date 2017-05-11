"""LCM type definitions
This file automatically generated by lcm.
DO NOT MODIFY BY HAND!!!!
"""

import cStringIO as StringIO
import struct

class lcmt_drake_signal(object):
    __slots__ = ["dim", "val", "coord", "timestamp"]

    def __init__(self):
        self.dim = 0
        self.val = []
        self.coord = []
        self.timestamp = 0

    def encode(self):
        buf = StringIO.StringIO()
        buf.write(lcmt_drake_signal._get_packed_fingerprint())
        self._encode_one(buf)
        return buf.getvalue()

    def _encode_one(self, buf):
        buf.write(struct.pack(">i", self.dim))
        buf.write(struct.pack('>%dd' % self.dim, *self.val[:self.dim]))
        for i0 in range(self.dim):
            __coord_encoded = self.coord[i0].encode('utf-8')
            buf.write(struct.pack('>I', len(__coord_encoded)+1))
            buf.write(__coord_encoded)
            buf.write("\0")
        buf.write(struct.pack(">q", self.timestamp))

    def decode(data):
        if hasattr(data, 'read'):
            buf = data
        else:
            buf = StringIO.StringIO(data)
        if buf.read(8) != lcmt_drake_signal._get_packed_fingerprint():
            raise ValueError("Decode error")
        return lcmt_drake_signal._decode_one(buf)
    decode = staticmethod(decode)

    def _decode_one(buf):
        self = lcmt_drake_signal()
        self.dim = struct.unpack(">i", buf.read(4))[0]
        self.val = struct.unpack('>%dd' % self.dim, buf.read(self.dim * 8))
        self.coord = []
        for i0 in range(self.dim):
            __coord_len = struct.unpack('>I', buf.read(4))[0]
            self.coord.append(buf.read(__coord_len)[:-1].decode('utf-8', 'replace'))
        self.timestamp = struct.unpack(">q", buf.read(8))[0]
        return self
    _decode_one = staticmethod(_decode_one)

    _hash = None
    def _get_hash_recursive(parents):
        if lcmt_drake_signal in parents: return 0
        tmphash = (0x236e73ecd6fc3932) & 0xffffffffffffffff
        tmphash  = (((tmphash<<1)&0xffffffffffffffff)  + (tmphash>>63)) & 0xffffffffffffffff
        return tmphash
    _get_hash_recursive = staticmethod(_get_hash_recursive)
    _packed_fingerprint = None

    def _get_packed_fingerprint():
        if lcmt_drake_signal._packed_fingerprint is None:
            lcmt_drake_signal._packed_fingerprint = struct.pack(">Q", lcmt_drake_signal._get_hash_recursive([]))
        return lcmt_drake_signal._packed_fingerprint
    _get_packed_fingerprint = staticmethod(_get_packed_fingerprint)

