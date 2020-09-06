import 'package:MyShop_App/Provider/Product.dart';
import 'package:MyShop_App/Provider/Products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, title: '', price: null, description: '', imageUrl: '');
  var _intitValue = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };
  bool isLoad = false;
  var isinit = true;
  @override
  void initState() {
    _imgUrlFocusNode.addListener(updateimg);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isinit) {
      final proid = ModalRoute.of(context).settings.arguments as String;
      if (proid != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(proid);
        _editProduct = product;
        _intitValue = {
          'title': _editProduct.title,
          'price': _editProduct.price.toString(),
          'description': _editProduct.description,
          'imageUrl': ''
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    isinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imgUrlFocusNode.removeListener(updateimg);
    _imgUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void updateimg() {
    if (!_imgUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _submitForm() async {
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return;
    }
    setState(() {
      isLoad = true;
    });

    _form.currentState.save();
    if (_editProduct.id != null) {
      await Provider.of<Products>(context)
          .updateProduct(_editProduct.id, _editProduct);
      setState(() {
        isLoad = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('thomething rong '),
            actions: <Widget>[
              FlatButton(
                child: Text('OKAY'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoad = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _submitForm)
        ],
      ),
      body: isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _intitValue['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is required';
                        }
                        return null; //تعنى انة خالى من الاخطاء
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            title: value,
                            price: _editProduct.price,
                            description: _editProduct.description,
                            imageUrl: _editProduct.imageUrl,
                            id: _editProduct.id,
                            isFavourt: _editProduct.isFavourt);
                      },
                    ),
                    TextFormField(
                      initialValue: _intitValue['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is required';
                        }
                        if (double.tryParse(value) ==
                            null) //يعنى القمية غير صحيحة
                        {
                          return 'please inter Valid number';
                        }
                        if (double.parse(value) <= 0) //يعنى القمية غير صحيحة
                        {
                          return 'please inter number gratet thn 0';
                        }
                        return null; //تعنى انة خالى من الاخطاء
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            title: _editProduct.title,
                            price: double.parse(value),
                            description: _editProduct.description,
                            imageUrl: _editProduct.imageUrl,
                            id: _editProduct.id,
                            isFavourt: _editProduct.isFavourt);
                      },
                    ),
                    TextFormField(
                      initialValue: _intitValue['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'required';
                        }
                        if (value.length < 10) {
                          return 'discrioption must be more than 10 char';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            title: _editProduct.title,
                            price: _editProduct.price,
                            description: value,
                            imageUrl: _editProduct.imageUrl,
                            id: _editProduct.id,
                            isFavourt: _editProduct.isFavourt);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imgUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _submitForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'required';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'invalid Img';
                              }
                              if (!value.endsWith('jpg') &&
                                  !value.endsWith('png') &&
                                  !value.endsWith('jpeg')) {
                                return 'invalid Img';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editProduct = Product(
                                  title: _editProduct.title,
                                  price: _editProduct.price,
                                  description: _editProduct.description,
                                  imageUrl: value,
                                  id: _editProduct.id,
                                  isFavourt: _editProduct.isFavourt);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
