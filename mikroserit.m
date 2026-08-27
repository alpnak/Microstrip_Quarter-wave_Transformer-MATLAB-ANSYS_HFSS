%% Sabitler

f = 2e9; % 2 GHz (Merkez frekansı)
Zs = 50; % 50 Ω (Kaynak empedansı)
Zl = 90; % 90 Ω (Yük empedansı)
h = 6e-4; % 600 µm (Polietilen katman yüksekliği)
Er = 2.4; % 2.4 (Bağıl elektriksel geçirgenlik)
c = 3e8; % 3x10⁸ m/s (Işığın boşluktaki hızı)
mu_0 = 4 * pi * 1e-7; % 4π10⁻⁷ H/m (Boşluğun manyetik geçirgenliği)
sigma_i = 0; % 0 S/m (Yalıtkan polietilen katmanın iletkenliği)
sigma_c = 5.8e7; % 5.8x10⁷ S/m (İletken bakır katmanın iletkenliği)
w = 2 * pi * f; % 1.2566x10¹⁰ rad/s (Açısal freknas)
lambda = c / f; % 0.15 m (2 GHz merkez frekansındaki elektromanyetik dalganın boşluktaki dalga boyu)


%% *Birinci Aşama*

%% *a. Hattın tasarım denklemlerini kullanarak mikroşerit hattın genişliğinin (_W_) belirlenmesi*

Zo = sqrt(Zs * Zl);

A = ((Zo / 60) * sqrt((Er + 1) / 2)) + (((Er - 1) / (Er + 1)) * (0.23 + (0.11 / Er)));
B = (377 * pi) / (2 * Zo * sqrt(Er));

W_h_orani_1 = (8 * exp(A)) / (exp(2 * A) - 2); % W / h < 2
W_h_orani_2 = (2 / pi) * (B - 1 - log(2 * B - 1) + ((Er - 1) / (2 * Er)) * (log(B - 1) + 0.39 - (0.61 / Er))); % W / h >= 2

if W_h_orani_1 < 2
    W_h_orani = W_h_orani_1;
else
    W_h_orani = W_h_orani_2;
end

W = W_h_orani * h;

fprintf("W = %.10f mm", W * 1000)

%% *b. Karakteristik empedans (_Zo_), etkin dielektrik sabiti (_Eeff_), faz katsayısı (_β_) ve zayıflama sabiti (_α_) değerlerinin hesaplanması*

% _Zo_ hesabı

Zo = sqrt(Zs * Zl);
fprintf("Zo = %.10f Ω", Zo)

% _Eeff_ hesabı

Eeff = ((Er + 1) / 2) + (Er - 1) / (2 * sqrt(1 + 12 * (h / W)));
fprintf("Eeff = %.10f", Eeff)

% _Eeff_'e bağlı faz hızı (_Vp_), etkin dalga boyu (_λeff)_ ve mikroşerit uzunluğu (_l)_ hesabı

Vp = c / sqrt(Eeff);
fprintf("Vp = %.10e m/s", Vp)

lambda_eff = Vp / f;
lambda_eff = c / (f * sqrt(Eeff));
lambda_eff = lambda / sqrt(Eeff);
fprintf("λeff = %.10f mm", lambda_eff * 1000)

l = lambda_eff / 4;
fprintf("l = %.10f mm", l * 1000)

% _*β_ ve _α_ değerlerinin hesaplanabilmesi için yayılım sabitinin bulunması (*_γ_*)*
%% 
% _γ_ ile ilgili olan dağıtık model parametrelerinin (_R, L, G, C_) hesabı

R = hesapla_R(f, w, mu_0, sigma_c);
L = hesapla_L(Zo, Vp);
G = hesapla_G(sigma_i, w, h);
C = hesapla_C(Vp, Zo);
%% 
% _γ_ hesabı

gamma = sqrt((R + 1i * w * L) * (G + 1i * w * C));
fprintf("Γ = %.10e + j%.10f", real(gamma), imag(gamma))
% _*β*_ hesabı

beta = w / Vp;
beta = w * sqrt(Eeff) / c;
beta = imag(gamma);
fprintf("β = %.10f rad/m", beta)
% _*α*_ hesabı

alfa = real(gamma);
fprintf("α = %.10e Np/m", alfa)
%% *c. Mikroşerit hat için dağıtık model parametrelerinin (_R, L, G, C_) hesaplanması*
% Birim uzunluktaki seri direnç (_R_)

fprintf('R: %.10e Ohm/m\n', R);
% Birim uzunluktaki seri endüktans (_L_)

fprintf('L: %.10e H/m\n', L);
% Birim uzunluktaki paralel iletkenlik (_G_)

fprintf('G: %i S/m\n', G);
% Birm uzunluktaki paralel kapasitans (_C_)

fprintf('C: %.10e F/m\n', C);
%% e. Mikroşerit hattın özellikleri kullanılarak, 2 GHz merkez frekansında [1 3] GHz bandında çalışan, _λeff/4_ uzunluğundaki çeyrek dalga dönüştürücü devresinin çalıştığının, yansıma katsayısının (_Γ_) genliğinin 0.1'den küçük olduğunun teorik olarak gösterilmesi, |_Γ|_'nın frekansa karşı grafiğinin oluşturulması

frekans = 1e9:1e8:3e9;
yansima_katsayisi = zeros(size(frekans));

for idx = 1:length(frekans)
    
    f = frekans(idx);
    w = 2 * pi * f;

    gamma = sqrt((R + 1i * w * L) * (G + 1i * w * C));
    
    Zin = Zo * ((Zl + Zo * tanh(gamma * l)) / (Zo + Zl * tanh(gamma * l)));

    yansima_katsayisi(idx) = abs((Zin - Zs) / (Zin + Zs));
end
% Frekans-|_Γ|_ grafiğinin oluşturulması

figure;
plot(frekans / 1e9, yansima_katsayisi);
xlabel('Frekans (GHz)');
ylabel('|\Gamma|');
title('Yansıma Katsayısı Genliğinin Frekansa Göre Değişimi');
grid on;
%% Dağıtık model parametreleri (_R, L, G, C_) hesaplama fonksiyonları

function R = hesapla_R(f, w, mu_0, sigma_c)    
    R = (2 / w) * sqrt(2 * pi * f * mu_0 / sigma_c);
end

function L = hesapla_L(Zo, Vp)
    L = Zo / Vp;
end

function G = hesapla_G(sigma_i, w, h)
    G = sigma_i * w / h;
end

function C = hesapla_C(Vp, Zo)
    C = 1 / (Vp * Zo);
end