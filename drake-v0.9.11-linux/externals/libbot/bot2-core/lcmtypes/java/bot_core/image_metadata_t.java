/* LCM type definition class file
 * This file was automatically generated by lcm-gen
 * DO NOT MODIFY BY HAND!!!!
 */

package bot_core;
 
import java.io.*;
import java.util.*;
import lcm.lcm.*;
 
public final class image_metadata_t implements lcm.lcm.LCMEncodable
{
    public String key;
    public int n;
    public byte value[];
 
    public image_metadata_t()
    {
    }
 
    public static final long LCM_FINGERPRINT;
    public static final long LCM_FINGERPRINT_BASE = 0x4d25b1a682bbfdc7L;
 
    static {
        LCM_FINGERPRINT = _hashRecursive(new ArrayList<Class<?>>());
    }
 
    public static long _hashRecursive(ArrayList<Class<?>> classes)
    {
        if (classes.contains(bot_core.image_metadata_t.class))
            return 0L;
 
        classes.add(bot_core.image_metadata_t.class);
        long hash = LCM_FINGERPRINT_BASE
            ;
        classes.remove(classes.size() - 1);
        return (hash<<1) + ((hash>>63)&1);
    }
 
    public void encode(DataOutput outs) throws IOException
    {
        outs.writeLong(LCM_FINGERPRINT);
        _encodeRecursive(outs);
    }
 
    public void _encodeRecursive(DataOutput outs) throws IOException
    {
        char[] __strbuf = null;
        __strbuf = new char[this.key.length()]; this.key.getChars(0, this.key.length(), __strbuf, 0); outs.writeInt(__strbuf.length+1); for (int _i = 0; _i < __strbuf.length; _i++) outs.write(__strbuf[_i]); outs.writeByte(0); 
 
        outs.writeInt(this.n); 
 
        if (this.n > 0)
            outs.write(this.value, 0, n);
 
    }
 
    public image_metadata_t(byte[] data) throws IOException
    {
        this(new LCMDataInputStream(data));
    }
 
    public image_metadata_t(DataInput ins) throws IOException
    {
        if (ins.readLong() != LCM_FINGERPRINT)
            throw new IOException("LCM Decode error: bad fingerprint");
 
        _decodeRecursive(ins);
    }
 
    public static bot_core.image_metadata_t _decodeRecursiveFactory(DataInput ins) throws IOException
    {
        bot_core.image_metadata_t o = new bot_core.image_metadata_t();
        o._decodeRecursive(ins);
        return o;
    }
 
    public void _decodeRecursive(DataInput ins) throws IOException
    {
        char[] __strbuf = null;
        __strbuf = new char[ins.readInt()-1]; for (int _i = 0; _i < __strbuf.length; _i++) __strbuf[_i] = (char) (ins.readByte()&0xff); ins.readByte(); this.key = new String(__strbuf);
 
        this.n = ins.readInt();
 
        this.value = new byte[(int) n];
        ins.readFully(this.value, 0, n); 
    }
 
    public bot_core.image_metadata_t copy()
    {
        bot_core.image_metadata_t outobj = new bot_core.image_metadata_t();
        outobj.key = this.key;
 
        outobj.n = this.n;
 
        outobj.value = new byte[(int) n];
        if (this.n > 0)
            System.arraycopy(this.value, 0, outobj.value, 0, this.n); 
        return outobj;
    }
 
}

