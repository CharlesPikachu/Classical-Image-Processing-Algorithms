%{
Author:
    Charles
Function:
    Compute iou.
Input:
    -box1: one of the boxes, (top_left_x, top_left_y, width, height).
    -box2: one of the boxes, (top_left_x, top_left_y, width, height).
Output:
    -iou: IoU = Overlapping area / (two boxes' total area - Overlapping area).
%}
function iou = bboxIoU(box1, box2)
mx = min(box1(1), box2(1));
Mx = max(box1(1)+box1(3), box2(1)+box2(3));
my = min(box1(2), box2(2));
My = max(box1(2)+box1(4), box2(2)+box2(4));
w1 = box1(3);
h1 = box1(4);
w2 = box2(3);
h2 = box2(4);
uw = Mx - mx;
uh = My - my;
cw = w1 + w2 - uw;
ch = h1 + h2 - uh;
if cw <=0 || ch <= 0
    iou = 0;
else
    area1 = w1 * h1;
    area2 = w2 * h2;
    carea = cw * ch;
    uarea = area1 + area2 - carea;
    iou = carea / uarea;
end
end