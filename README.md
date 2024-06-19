The impact of bias in datasets on fairness of models predictions is a subject of ongoing research across multiple domains. In this study we systematically examine the diagnosis accuracy of different CNN architectures, using skin lesions images as input, focusing on variations of demographic parameters, particularly sex, in the training data. More specially, we used a balanced test set, and constructed five equally sized train sets where female-male ratio varied (only female; 75:25; 50:50; 25:75; only male). The ratio benign-malignant was 50:50 for all six datasets. We evaluated the model performance for three different learning strategies – a single task model, a multi-task model, and an adversarial learning scheme. We observe that: 1) single task models reveal sex bias, 2) multi-task models eliminate sex bias from balanced or female-skewed data, 3) adversarial approach eliminates sex bias for the female-only case, and 4) male-inclusive datasets enhance model performance for males despite female majority.
It is hard to generalize from these findings. Future research is planned to look at more demographic attributes, like age, and other possibly confounding factors such as skin color and artefacts (e.g. markings) in the images.

Here is a description of the repository structure and files:

0_data: contains the metadata of the collected skin-lesions (from the ISIC archive [1,2,3,4,5,6])
1_code: contains the baseline and multi-task models.



[1] Codella, N., Rotemberg, V., Tschandl, P., Celebi, M.E., Dusza, S., Gutman, D.,
Helba, B., Kalloo, A., Liopyris, K., Marchetti, M., Kittler, H., Halpern, A.: Skin
lesion analysis toward melanoma detection 2018: A challenge hosted by the inter-
national skin imaging collaboration (isic) (2019)

[2] Codella, N.C.F., Gutman, D., Celebi, M.E., Helba, B., Marchetti, M.A., Dusza,
S.W., Kalloo, A., Liopyris, K., Mishra, N., Kittler, H., Halpern, A.: Skin lesion
analysis toward melanoma detection: A challenge at the 2017 international sym-
posium on biomedical imaging (isbi), hosted by the international skin imaging
collaboration (isic) (2018)

[3] Combalia, M., Codella, N.C.F., Rotemberg, V., Helba, B., Vilaplana, V., Reiter,
O., Carrera, C., Barreiro, A., Halpern, A.C., Puig, S., Malvehy, J.: Bcn20000:
Dermoscopic lesions in the wild (2019)

[4] Gutman, D., Codella, N.C.F., Celebi, E., Helba, B., Marchetti, M., Mishra, N.,
Halpern, A.: Skin lesion analysis toward melanoma detection: A challenge at the
international symposium on biomedical imaging (isbi) 2016, hosted by the inter-
national skin imaging collaboration (isic) (2016)

[5] Tschandl, P., Rosendahl, C., Kittler, H.: The HAM10000 dataset, a large collection
of multi-source dermatoscopic images of common pigmented skin lesions (2018)

[6] Veronica, R., Nicholas, K., Brigid, B.S., Liam, C., Emmanouil, C., Noel, C.,
Marc, C., Dusza, S., Pascale, G., Gutman, D., Halpern, A., Brian, H., Harald,
K., Kivanc, K., Langer, S., Konstantinos, L., Josep, M., Shenara, M., Jabpani,
N., Ofer, R., Shih, G., Alexander, S., Philipp, T., Weber, J., Peter, S.H., Univer-
sity of Athens Medical School, Athens, Greece (GRID:grid. 5216. 0) (ISNI:0000
0001 2155 0800), SUNY Downstate Medical School, New York, USA (GRID:grid.
262863. b) (ISNI:0000 0001 0693 2202), Stony Brook Medical School, Stony Brook,
USA (GRID:grid. 51462. 34), Rabin Medical Center, Tel Aviv, Israel (GRID:grid.
413156. 4) (ISNI:0000 0004 0575 344X): A patient-centric dataset of images and
metadata for identifying melanomas using clinical context. Scientific Data; London
8(1), s41597–021 (2021)