% Applies each of the filters in the filterbank FB to the image I.
%
% To apply to a stack of images:
%  IFS = fevalArrays( images, @FbApply2d, FB, 'valid' );
%
% USAGE
%  FR = FbApply2d( I, FB, [shape], [show] )
%
% INPUTS
%  I       - 2D input array
%  FB      - filterbank - MxNxK set of K filters each of size MxN
%  shape   - ['full'] option for conv2 'full', 'same', 'valid'
%  show    - [0] first figure to use for optional display
%
% OUTPUTS
%  FR      - 3D set of filtered images
%
% EXAMPLE
%  load trees;  X=imresize(X,.5);  load FbDoG.mat;
%  FR = FbApply2d( X, FB, 'same', 1 );
%
% See also CONV2, FBMAKE

% Piotr's Image&Video Toolbox      Version NEW
% Written and maintained by Piotr Dollar    pdollar-at-cs.ucsd.edu
% Please email me if you find bugs, or have suggestions or questions!

function FR = FbApply2d( I, FB, shape, show )

if( nargin<3 || isempty(shape)); shape = 'full'; end
if( nargin<4 || isempty(show)); show=0; end

nd=ndims(I);  ndf=ndims(FB);  nf=size(FB,3);
if( nd~=2  ); error('I must be an MxN array'); end
if( ndf~=2 && ndf~=3 ); error('FB must be an MxN or MxNxK array'); end
if( ~isa(I,'double')); I = double(I); end

% apply each filter to image
if( ndf==2 )
  FR = conv2( I, FB, shape );
else
  FR = repmat( conv2(I,FB(:,:,1),shape), [1 1 nf] );
  for i=2:nf; FR(:,:,i)=conv2(I,FB(:,:,i),shape); end
end

% optionally display
if( show )
  figure(show); im(I);
  figure(show+1); montage2(FB,struct('extraInfo',1));
  figure(show+2); montage2(FR,struct('extraInfo',1));
end
