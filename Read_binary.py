import torch

file = torch.load("Animal_classification/precheckpoint/animals/last.pt",
                  map_location=torch.device('cpu'))
print(file.keys())
print(f"epoch: {file['epoch']}")
print(f"acc: {file['best_acc']}")
print(f"optimze: {file['optimize']}")