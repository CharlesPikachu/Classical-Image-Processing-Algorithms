%{
Author:
    Charles
Function:
    Reading header of Truevision TARGA file, TGA, VDA, ICB VST.
Input:
    -fname: filename.
Output:
    -info: file-header.
%}
function info = readTgaHeader(fname)
if(exist('fname', 'var') == 0)
    [filename, pathname] = uigetfile('*.tga;*.vda;*.icb,*.vst', 'Read tga-file');
    fname = [pathname filename];
end
f = fopen(fname, 'rb', 'l');
if(f < 0)
    fprintf('could not open file %s\n', fname);
    return
end
info.Filename = fname;
fseek(f, -26, 'eof');
info.ExtensionArea = fread(f, 1, 'long');
info.DeveloperDirectory = fread(f, 1, 'long');
info.Signature = fread(f, 17, 'char=>char')';
if(strcmp(info.Signature, 'TRUEVISION-XFILE.'))
    info.Version = 'new';
else
    info.Version = 'old';
end
fseek(f, 0, 'bof');
info.IDlength = fread(f, 1, 'uint8');
info.ColorMapType = fread(f, 1, 'uint8');
info.ImageType = fread(f, 1, 'uint8');
switch(info.ImageType)
    case 0
        info.ImageTypeString = 'No Image Data';
        info.Rle = false;
    case 1
        info.ImageTypeString = 'Uncompressed, Color-mapped image'; 
        info.Rle = false;
    case 2
        info.ImageTypeString = 'Uncompressed, True-color image';
        info.Rle = false;
    case 3
        info.ImageTypeString = 'Uncompressed, True-color image';
        info.Rle = false;
    case 9
        info.ImageTypeString = 'Run-length encoded Color-mapped Image'; 
        info.Rle = true;
    case 10
        info.ImageTypeString = 'Run-length encoded True-color Image Image'; 
        info.Rle = true;
    case 11
        info.ImageTypeString = 'Run-length encoded Black-and-white Image';
        info.Rle = true;
    otherwise
        info.ImageTypeString = 'unknown';
        info.Rle = false;
end
info.ColorMapStart = fread(f, 1, 'short');
info.ColorMapLength = fread(f, 1, 'short');
info.ColorMapBits = fread(f, 1, 'uint8');
info.ColorMapStoreBits = 8 * ceil(info.ColorMapBits / 8);
info.XOrigin = fread(f, 1, 'short');
info.YOrigin  = fread(f, 1, 'short');
info.Width = fread(f, 1, 'short');
info.Height = fread(f, 1, 'short');
info.Depth = fread(f, 1, 'uint8');
b = bitget(fread(f, 1, 'uint8=>uint8'), 1: 8);
info.ImageDescriptor = b;
info.AlphaChannelBits = b(1) + b(2) * 2 + b(3) * 4 + b(4) * 8;
if((b(6)==0)&&(b(5)==0)), info.ImageOrigin = 'bottom left'; end
if((b(6)==0)&&(b(5)==1)), info.ImageOrigin = 'bottom right'; end
if((b(6)==1)&&(b(5)==0)), info.ImageOrigin = 'top left'; end
if((b(6)==1)&&(b(5)==1)), info.ImageOrigin = 'top right'; end
info.ImageID = fread(f, info.IDlength, 'uint8');
if(info.ColorMapType == 0)
    info.ColorMap = [];
else
    ColorMap = fread(f, info.ColorMapLength * (info.ColorMapStoreBits / 8), 'uint8=>uint8');
    switch(info.ColorMapStoreBits)
        case 16
            % BitsPerColor = min(info.bits/3, 8);
            % info.ColorMap = reshape(ColorMap, [info.ColorMapLength 2]);
        case 24
            info.ColorMap = reshape(ColorMap, [3 info.ColorMapLength])';
            info.ColorMap = info.ColorMap(:, 3: -1: 1);
        case 32
            info.ColorMap = reshape(ColorMap, [4 info.ColorMapLength])';
            info.ColorMap = info.ColorMap(:, [3 2 1 4]);
    end
    info.ColorMap = double(info.ColorMap) / 255;
end
info.HeaderSize = ftell(f);
fseek(f, 0, 'eof');
info.FileSize = ftell(f);
fclose(f);
end