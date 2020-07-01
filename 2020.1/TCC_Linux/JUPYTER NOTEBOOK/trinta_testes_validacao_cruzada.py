class TrintaTestes():

    def __init__(self, classificador, previsores, classe, columns_=None):
        from sklearn.model_selection import StratifiedKFold
        from sklearn.tree import DecisionTreeClassifier
        from sklearn.ensemble import RandomForestClassifier
        import numpy as np
        import pandas as pd
        from sklearn.metrics import accuracy_score, f1_score, precision_score, recall_score, classification_report,    confusion_matrix
        
        self.acuracia_final = []
        self.precision_final = []
        self.recall_final = []
        self.f1_score_final = []        
        self.matriz_final = []        
        self.caracteristicas_importantes = []
        self.StratifiedKFold = StratifiedKFold

        for i in range(30):
            kfold = self.StratifiedKFold(n_splits=10, shuffle=True, random_state = i)
            acuracia_parcial = []
            precision_parcial = []
            recall_parcial = []
            f1_score_parcial = []  
            matriz_parcial = []

            for indice_treinamento, indice_teste in kfold.split(previsores, np.zeros(shape=(classe.shape[0], 1))):
                
                # treinamento
                classificador.fit(previsores[indice_treinamento], classe[indice_treinamento]) 
                
                if (type(classificador) is RandomForestClassifier) or (type(classificador) is DecisionTreeClassifier):
                    # verificando atributos mais importantes        
                    self.caracteristicas_importantes.append(pd.DataFrame(classificador.feature_importances_,
                                                         index = columns_,
                                                         columns = ['importance']).sort_values('importance', ascending = False))
                    
                # teste
                previsoes = classificador.predict(previsores[indice_teste])
                
                
                # Métricas
                
                # verificação de acurácia
                acuracia_parcial.append(accuracy_score(classe[indice_teste], previsoes)) 
                
                # verificação da precisão
                precision_parcial.append(precision_score(classe[indice_teste], previsoes, average="macro"))
                
                # verificação de recall
                recall_parcial.append(recall_score(classe[indice_teste], previsoes, average="macro"))
                
                # verificação do f1 score
                f1_score_parcial.append(f1_score(classe[indice_teste], previsoes, average="macro"))             
            
                # matriz de confusão
                matriz_parcial.append(confusion_matrix(classe[indice_teste], previsoes))

            # verificação de acurácia
            acuracia_parcial = np.asarray(acuracia_parcial)
            self.acuracia_final.append(acuracia_parcial.mean())
            
            # verificação da precisão
            precision_parcial = np.asarray(precision_parcial)
            self.precision_final.append(precision_parcial.mean())
            
            # verificação de recall
            recall_parcial = np.asarray(recall_parcial)
            self.recall_final.append(recall_parcial.mean())
            
            # verificação de f1 score
            f1_score_parcial = np.asarray(f1_score_parcial)
            self.f1_score_final.append(f1_score_parcial.mean())
            
            # matriz de confusão
            self.matriz_final.append(np.mean(matriz_parcial, axis = 0))
        
        # transformando todas as métricas finais em array numpy
        self.acuracia_final = np.asarray(self.acuracia_final)
        self.precision_final = np.asarray(self.precision_final)
        self.recall_final = np.asarray(self.recall_final)
        self.f1_score_final = np.asarray(self.f1_score_final)
        self.matriz_final = np.mean(self.matriz_final, axis = 0)

    def acuracia(self):        
        return self.acuracia_final
    
    def precisao(self):
        return self.precision_final
    
    def recall(self):
        return self.recall_final
    
    def f1_score(self):
        return self.f1_score_final

    def matrizConfusao(self):
        return self.matriz_final
    
    def importances(self):
        return self.caracteristicas_importantes
            