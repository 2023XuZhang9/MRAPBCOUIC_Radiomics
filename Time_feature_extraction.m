a = importdata('/home3/Feature_folder/Tumor_feature_dyn0.txt');
data0 = a.data;
data0=data0';

a = importdata('/home3/Feature_folder/Tumor_feature_dyn1.txt');
data1 = a.data;
data1 = data1';

a = importdata('/home3/Feature_folder/Tumor_feature_dyn2.txt');
data2 = a.data;
data2 = data2';

a = importdata('/home3/Feature_folder/Tumor_feature_dyn3.txt');
data3 = a.data;
data3 = data3';

shape_feature = data0(:,1:14);
dyn0=data0(:,15:end);
dyn1=data1(:,15:end);
dyn2=data2(:,15:end);
dyn3=data3(:,15:end);

% dyn0(find(isnan(dyn0)==1)) = 0;
% dyn1(find(isnan(dyn1)==1)) = 0;
% dyn2(find(isnan(dyn2)==1)) = 0;
% dyn3(find(isnan(dyn3)==1)) = 0;

pat_num=size(dyn0,1);
feature_num=size(dyn0,2);

skeall=zeros(pat_num,feature_num);
kurall=zeros(pat_num,feature_num);
meall=zeros(pat_num,feature_num);
vaall=zeros(pat_num,feature_num);
enhance10=zeros(pat_num,feature_num);
enhance21=zeros(pat_num,feature_num);
enhance32=zeros(pat_num,feature_num);
enhance30=zeros(pat_num,feature_num);
for i =1:pat_num
    for j =1:feature_num
        new_time_feature_matrix=[dyn0(i,j) dyn1(i,j) dyn2(i,j) dyn3(i,j)];
        ske=skewness(new_time_feature_matrix);
        kur=kurtosis(new_time_feature_matrix);
        me=mean(new_time_feature_matrix);
        va=var(new_time_feature_matrix);
        skeall(i,j)=ske;
        kurall(i,j)=kur;
        meall(i,j)=me;
        vaall(i,j)=va;
        enhance10(i,j)=(dyn1(i,j)-dyn0(i,j))/dyn0(i,j);
        enhance21(i,j)=(dyn2(i,j)-dyn1(i,j))/dyn1(i,j);
        enhance32(i,j)=(dyn3(i,j)-dyn2(i,j))/dyn2(i,j);
        enhance30(i,j)=(dyn3(i,j)-dyn0(i,j))/dyn0(i,j);
    end
end

allfeature=[shape_feature,dyn0,dyn1,dyn2,dyn3,skeall,meall,vaall,enhance10,enhance21,enhance32,enhance30];

feature=allfeature;
for i=1:size(feature,2)
    one_feature_class=feature(:,i);
    nanlist=isnan(one_feature_class);
    if sum(nanlist)>0
        nonnan_index=find(nanlist==0);
        nan_index=find(nanlist==1);
        feature(nan_index,i)=mean(one_feature_class(nonnan_index));
    end
end