class ClienteModel {
  String? id;
  String nome;
  String cpfCnpj;
  String telefone;
  String cidade;

  ClienteModel({
    this.id,
    required this.nome,
    required this.cpfCnpj,
    required this.telefone,
    required this.cidade,
  });

  // Converte o que vem da API (JSON) para o Flutter
  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'],
      nome: json['nome'],
      cpfCnpj: json['cpfCnpj'],
      telefone: json['telefone'],
      cidade: json['cidade'],
    );
  }

  // Prepara o dado para enviar para a API (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpfCnpj': cpfCnpj,
      'telefone': telefone,
      'cidade': cidade,
    };
  }
}