function [fstd,fsttd] = get_fsdata(path,td,ttd,feature_size)
load(path);
selected_feature = importance_order(1:feature_size);
fstd = td(:,selected_feature);
fsttd = ttd(:,selected_feature);
end