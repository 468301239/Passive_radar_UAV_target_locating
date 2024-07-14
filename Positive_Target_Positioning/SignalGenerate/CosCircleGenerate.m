% ����Բ�����ź�
% ����1��radar �״�
% ����2��target Ŀ��
% ����3��f0 ��Ƶ
% ����4��t ����ʱ��
% ����5��sampleNum ������
% ����6��generate_noise �������� (�������ֵΪ��������� ����ֵΪnan or inf ��Ч)
function Signal = CosCircleGenerate(radar, target, f0, ...
    t, sampleNum, SNR)
    
    if nargin == 2
        f0  = 5.8e9;
        t = 1e-10; % seconds
        sampleNum = 256;
        SNR = 15;
    end
    
    Signal = {}; % �ź�
    for rr = 1:length(radar)
        A = [];
        for tt = 1:length(target)
            deltaPos = target{tt}.Pos - radar{rr}.Pos;
            xyPos    = norm(deltaPos(1:2));
            xPos     = deltaPos(1); % λ��x
            yPos     = deltaPos(2); % λ��y
            zPos     = deltaPos(3); % λ��z
            theta    = atan2(yPos, xPos);  % ��λ��
            fai      = atan2(zPos, xyPos); % ������
%             theta    = theta_(tt);
%             fai      = fai_(tt);

            % �״����
            r0     = radar{rr}.r0; % �״�뾶
            M      = radar{rr}.M;  % �״�����
            c      = 3e8;      % ����
            lambda = c / f0;   % ����
            % Ŀ�����
            RCS    = target{tt}.RCS; % Ŀ��RCS
            TarPos = target{tt}.Pos;
            % �ӳ�ʱ��
            tau      = r0 / lambda * cos(theta - 2 * pi * (0:M-1) / M) * sin(fai);
            % ����ʸ��
            A(:, tt) = exp(1j * 2 * pi * tau).';
            % ��ȡ����
            amp(tt) = radar{rr}.Pr(RCS, lambda, TarPos);
        end
        % ʱ��
        dt       = linspace(1, t, sampleNum);
        % �ź�����
        S = exp(1j * f0 * pi * dt);
        S = repmat(S, [length(target), 1]);
        X = A * S;
        
        % ���������
        if isnan(SNR) || isinf(SNR)
            
        else
           X = awgn(X, SNR);
        end
        Signal{rr} = X;
    end
end