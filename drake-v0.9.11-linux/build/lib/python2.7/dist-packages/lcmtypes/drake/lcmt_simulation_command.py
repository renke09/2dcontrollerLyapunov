"""LCM type definitions
This file automatically generated by lcm.
DO NOT MODIFY BY HAND!!!!
"""

import cStringIO as StringIO
import struct

class lcmt_simulation_command(object):
    __slots__ = ["timestamp", "command_type", "string_data", "num_float_data", "float_data"]

    RUN = 0
    PAUSE = 1
    STOP = 2
    RESTART = 3
    SHUTDOWN = 4

    def __init__(self):
        self.timestamp = 0
        self.command_type = 0
        self.string_data = ""
        self.num_float_data = 0
        self.float_data = []

    def encode(self):
        buf = StringIO.StringIO()
        buf.write(lcmt_simulation_command._get_packed_fingerprint())
        self._encode_one(buf)
        return buf.getvalue()

    def _encode_one(self, buf):
        buf.write(struct.pack(">qb", self.timestamp, self.command_type))
        __string_data_encoded = self.string_data.encode('utf-8')
        buf.write(struct.pack('>I', len(__string_data_encoded)+1))
        buf.write(__string_data_encoded)
        buf.write("\0")
        buf.write(struct.pack(">i", self.num_float_data))
        buf.write(struct.pack('>%df' % self.num_float_data, *self.float_data[:self.num_float_data]))

    def decode(data):
        if hasattr(data, 'read'):
            buf = data
        else:
            buf = StringIO.StringIO(data)
        if buf.read(8) != lcmt_simulation_command._get_packed_fingerprint():
            raise ValueError("Decode error")
        return lcmt_simulation_command._decode_one(buf)
    decode = staticmethod(decode)

    def _decode_one(buf):
        self = lcmt_simulation_command()
        self.timestamp, self.command_type = struct.unpack(">qb", buf.read(9))
        __string_data_len = struct.unpack('>I', buf.read(4))[0]
        self.string_data = buf.read(__string_data_len)[:-1].decode('utf-8', 'replace')
        self.num_float_data = struct.unpack(">i", buf.read(4))[0]
        self.float_data = struct.unpack('>%df' % self.num_float_data, buf.read(self.num_float_data * 4))
        return self
    _decode_one = staticmethod(_decode_one)

    _hash = None
    def _get_hash_recursive(parents):
        if lcmt_simulation_command in parents: return 0
        tmphash = (0xc8564b028f6c8abe) & 0xffffffffffffffff
        tmphash  = (((tmphash<<1)&0xffffffffffffffff)  + (tmphash>>63)) & 0xffffffffffffffff
        return tmphash
    _get_hash_recursive = staticmethod(_get_hash_recursive)
    _packed_fingerprint = None

    def _get_packed_fingerprint():
        if lcmt_simulation_command._packed_fingerprint is None:
            lcmt_simulation_command._packed_fingerprint = struct.pack(">Q", lcmt_simulation_command._get_hash_recursive([]))
        return lcmt_simulation_command._packed_fingerprint
    _get_packed_fingerprint = staticmethod(_get_packed_fingerprint)
