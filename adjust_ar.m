function bbr = adjust_ar( bb, flag, ar )
% Fix bb aspect ratios (without moving the bb centers).
%
% The w or h of each bb is adjusted so that w/h=ar.
% The parameter flag controls whether w or h should change:
%  flag==0: expand bb to given ar
%  flag==1: shrink bb to given ar
%  flag==2: use original w, alter h
%  flag==3: use original h, alter w
%  flag==4: preserve area, alter w and h
% If ar==1 (the default), always converts bb to a square, hence the name.
%
% USAGE
%  bbr = adjust_ar( bb, flag, [ar] )
%
% INPUTS
%  bb     - [nx4] original bbs
%  flag   - controls whether w or h should change
%  ar     - [1] desired aspect ratio
%
% OUTPUT
%  bbr    - the output 'adjusted' bbs
%
% EXAMPLE
%  bbr = adjust_ar([0 0 1 2],0)
%
% See also bbApply, bbApply>resize
if(nargin<3 || isempty(ar)), ar=1; end; bbr=bb;
if(flag==4), bbr=resize(bb,0,0,ar); return; end
for i=1:size(bb,1), p=bb(i,1:4);
  usew = (flag==0 && p(3)>p(4)*ar) || (flag==1 && p(3)<p(4)*ar) || flag==2;
  if(usew), p=resize(p,0,1,ar); else p=resize(p,1,0,ar); end; bbr(i,1:4)=p;
end
end

function bb = resize( bb, hr, wr, ar )
% Resize the bbs (without moving their centers).
%
% If wr>0 or hr>0, the w/h of each bb is adjusted in the following order:
%  if(hr~=0), h=h*hr; end
%  if(wr~=0), w=w*wr; end
%  if(hr==0), h=w/ar; end
%  if(wr==0), w=h*ar; end
% Only one of hr/wr may be set to 0, and then only if ar>0. If, however,
% hr=wr=0 and ar>0 then resizes bbs such that areas and centers are
% preserved but aspect ratio becomes ar.
%
% USAGE
%  bb = bbApply( 'resize', bb, hr, wr, [ar] )
%
% INPUTS
%  bb     - [nx4] original bbs
%  hr     - ratio by which to multiply height (or 0)
%  wr     - ratio by which to multiply width (or 0)
%  ar     - [0] target aspect ratio (used only if hr=0 or wr=0)
%
% OUTPUT
%  bb    - [nx4] the output resized bbs
%
% EXAMPLE
%  bb = bbApply('resize',[0 0 1 1],1.2,0,.5) % h'=1.2*h; w'=h'/2;
%
% See also bbApply, bbApply>squarify
if(nargin<4), ar=0; end; assert(size(bb,2)>=4);
assert((hr>0&&wr>0)||ar>0);
% preserve area and center, set aspect ratio
if(hr==0 && wr==0), a=sqrt(bb(:,3).*bb(:,4)); ar=sqrt(ar);
  d=a*ar-bb(:,3); bb(:,1)=bb(:,1)-d/2; bb(:,3)=bb(:,3)+d;
  d=a/ar-bb(:,4); bb(:,2)=bb(:,2)-d/2; bb(:,4)=bb(:,4)+d; return;
end
% possibly adjust h/w based on hr/wr
if(hr~=0), d=(hr-1)*bb(:,4); bb(:,2)=bb(:,2)-d/2; bb(:,4)=bb(:,4)+d; end
if(wr~=0), d=(wr-1)*bb(:,3); bb(:,1)=bb(:,1)-d/2; bb(:,3)=bb(:,3)+d; end
% possibly adjust h/w based on ar and NEW h/w
if(~hr), d=bb(:,3)/ar-bb(:,4); bb(:,2)=bb(:,2)-d/2; bb(:,4)=bb(:,4)+d; end
if(~wr), d=bb(:,4)*ar-bb(:,3); bb(:,1)=bb(:,1)-d/2; bb(:,3)=bb(:,3)+d; end
end