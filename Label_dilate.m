src = '/home3/Data';
file = dir(src);
file = file(3:end);

for i=1:length(file)
    label_file = [src,filesep,file(i).name,filesep,'label.nii.gz'];
    info = niftiinfo(label_file);
    V1 = spm_vol(label_file);
    Y1 = spm_read_vols(V1);
    Y1_new=zeros(size(Y1));
    res=info.PixelDimensions(1);
    pixel_size=5/res;
    SE = strel('sphere',round(pixel_size));
    for j=1:size(Y1,3)
        if sum(sum(Y1(:,:,j)))>0
            aims_Y1=Y1(:,:,j);
            imdilate_area=imdilate(aims_Y1,SE);
            Y1_new(:,:,j)=imdilate_area-aims_Y1;
        end 
    end
    
    V2=V1;
    new_name = [src,filesep,file(i).name,filesep,'label_dilate.nii'];
    V2.fname = new_name;
    spm_write_vol(V2,Y1_new);
    gzip(new_name);
    delete(new_name);
end