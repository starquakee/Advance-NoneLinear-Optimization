clear all
x=0:0.02:0.8;
y=x;
%prepareXaxisdata
%prepareYaxis data
%prepareX,Ydataforcontourplot
%prepareZdataforcontourplot
[CData.xi,CData.yi]=meshgrid(x,y); 
for j=1:length(x)
    for k=1:length(y) 
        CData.zi(j,k)=two_peaks([x(j),y(k)]); % 调用 two_peaks 函数
    end  
end
x0=[0.1 0.1];
B.lb=[0 0]';
B.ub=[0.8 0.8]';
[x_opt,f_opt]=rnd_search('two_peaks',x0,B,CData,80,1e-5); 
fprintf('Final solution:%f %f\n',x_opt(1),x_opt(2)); 
disp(['Function value: ',num2str(f_opt)]);



% 函数 two_peaks 定义在这里
function z = two_peaks(x)
    z = (((x(1)-0.5).^2+(x(2)-0.5).^2).*((x(1)+0.5).^2+(x(2)+0.5).^2)).^(0.5); 
end

function[x,f]=rnd_search(fun,x,B,CData,max_iter,tol_x)
X{1}=x;
f=feval(fun,x); 
range=0.2*norm(B.ub-B.lb); 
count=1;
while count<max_iter && norm(range)>=tol_x 
    step=(B.ub-B.lb).*(rand(2,1)-0.5)*range; 
    x_new=max(min(x+step,B.ub),B.lb);
    f_new=feval(fun,x_new); 
    rnd_plot(CData,X,x,2,x_new);
    if f_new<f 
        range=range*2.0; 
        x=x_new; f=f_new; 
        X{length(X)+1}=x; 
        rnd_plot(CData,X,x,1); 
    else
        range=range/1.3;  
    end 
    count=count+1;
end
rnd_plot(CData,X,x,3); %plotfinaldata
end

function rnd_plot(CData,X,x,mode,varargin) 
contour(CData.xi,CData.yi,CData.zi,20); %plotcontour 
colormap([0 0 1]); %changecolor
hold on; 
plot(X{1}(1),X{1}(2),'co','MarkerSize',5);
for j=2:length(X) %plotallstepsuptonow
%markprevioussolution
    plot(X{j}(1),X{j}(2),'co','MarkerSize',5);
    plot([X{j}(1) X{j-1}(1)],[X{j}(2) X{j-1}(2)],'c');
end 
plot(x(1),x(2),'rx','LineWidth',2,'MarkerSize',8);
if mode==2 %plotnewtrial 
    x_new=varargin{1};
    plot([x(1) x_new(1)],[x(2) x_new(2)],'m');
    plot(x_new(1),x_new(2),'gx','LineWidth',2,'MarkerSize',8); 
elseif mode==3 %markfinalsolution
    plot(x(1),x(2),'ro','LineWidth',2,'MarkerSize',12); 
end
hold off;
pause(0.1);
end
