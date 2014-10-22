package com.squint.app;

import com.squint.app.data._PARAMS;
import com.squint.app.widget.BaseActivity;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebSettings.PluginState;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;


@SuppressLint("SetJavaScriptEnabled")
public class AbstractDetailsActivity extends BaseActivity {
	
	public static final String TAG = AbstractDetailsActivity.class.getSimpleName();
	public static final String 		ACTION_SELECT 					  = "com.squint.action.abstract.select";
	public static final String 		EXTRA_ABSTRACT_ID	  			  = "com.squint.data.abstract.ID";
	public static final String 		EXTRA_ABSTRACT_NAME	  		      = "com.squint.data.abstract.NAME";
	public static final String 		EXTRA_ABSTRACT_CONTENT	  	      = "com.squint.data.abstract.CONTENT";	
	public static final String 		EXTRA_ABSTRACT_PDF			      = "com.squint.data.abstract.PDF";
	public static final String 		EXTRA_ABSTRACT_AUTHOR			  = "com.squint.data.abstract.AUTHOR";
	public static final String 		EXTRA_ABSTRACT_AUTHOR_ID		  = "com.squint.data.abstract.AUTHOR_ID";
	
	private TextView 		mName;
	private TextView 		mAuthor;
	private TextView 		mDetails;
	private TextView 		mContent;
	private WebView			mPdf;
		
	// ParseObject
	private static String  oid;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.details_abstract);
		// Header Configuration
		mTitle.setText(getString(R.string.title_section1));
		configOptions(OPTION_BACK, OPTION_NONE);
				
		mName 			= (TextView)findViewById(R.id.name);
		mAuthor	 		= (TextView)findViewById(R.id.author);
		mContent	 	= (TextView)findViewById(R.id.content);
		mDetails 		= (TextView)findViewById(R.id.author_details);
		mPdf	 		= (WebView)findViewById(R.id.pdf);
		mPdf.getSettings().setJavaScriptEnabled(true);
		mPdf.getSettings().setPluginState(PluginState.ON);
		mPdf.setWebViewClient(new WebViewClient() {
			@Override
	        public boolean shouldOverrideUrlLoading(WebView view, String url) {
	            return(false);
	        }
		});

	}
	
	@Override
	public void onResume() {
		super.onResume();
		
		Intent intent 	= getIntent();		
		oid	= intent.getStringExtra(EXTRA_ABSTRACT_ID);
		mName.setText(intent.getStringExtra(EXTRA_ABSTRACT_NAME));
		mAuthor.setText(intent.getStringExtra(EXTRA_ABSTRACT_AUTHOR));
		mContent.setText(intent.getStringExtra(EXTRA_ABSTRACT_CONTENT));
		
		final String pdf = intent.getStringExtra(EXTRA_ABSTRACT_PDF);

		mDetails.setContentDescription(intent.getStringExtra(EXTRA_ABSTRACT_AUTHOR_ID));
		mDetails.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				String details = v.getContentDescription().toString();
				openPdf(pdf);

				Log.d(TAG, "oid/details: " + oid + "/ " + details);				
			}
		});
		
		loadPdf(intent.getStringExtra(EXTRA_ABSTRACT_PDF));
	}
	
	// Use WebView via google docs engine	
	private void loadPdf(String url) {	
		mPdf.loadUrl(_PARAMS.GOOGLE_DOCS_URL_EXTERNAL + url);
		//mPdf.loadUrl(_PARAMS.GOOGLE_DOCS_URL_INTERNAL + url);
	}
	
	private void openPdf(String url) {
		Intent intent = new Intent(Intent.ACTION_VIEW);
		intent.setDataAndType(Uri.parse(_PARAMS.GOOGLE_DOCS_URL_EXTERNAL + url), "text/html");
		startActivity(intent);

	}
	
	/*
	private void convertPdfToImage() {
	        try {
	            String sourceDir = "C:/Documents/Chemistry.pdf";// PDF file must be placed in DataGet folder
	            String destinationDir = "C:/Documents/Converted/";//Converted PDF page saved in this folder

	        File sourceFile = new File(sourceDir);
	        File destinationFile = new File(destinationDir);

	        String fileName = sourceFile.getName().replace(".pdf", "_cover");

	        if (sourceFile.exists()) {
	            if (!destinationFile.exists()) {
	                destinationFile.mkdir();
	                System.out.println("Folder created in: "+ destinationFile.getCanonicalPath());
	            }

	            RandomAccessFile raf = new RandomAccessFile(sourceFile, "r");
	            FileChannel channel = raf.getChannel();
	            ByteBuffer buf = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
	            PDFFile pdf = new PDFFile(buf);
	            int pageNumber = 62;// which PDF page to be convert
	            PDFPage page = pdf.getPage(pageNumber);
	            Log.d(TAG, "PDF TOTAL PAGES: " + pdf.getNumPages());

	            
	            // create the image
	            Rectangle rect = new Rectangle(0, 0, (int) page.getBBox().getWidth(), (int) page.getBBox().getHeight());
	            BufferedImage bufferedImage = new BufferedImage(rect.width, rect.height, BufferedImage.TYPE_INT_RGB);

	            // width & height, // clip rect, // null for the ImageObserver, // fill background with white, // block until drawing is done
	            Image image = page.getImage(rect.width, rect.height, rect, null, true, true );
	            Graphics2D bufImageGraphics = bufferedImage.createGraphics();
	            bufImageGraphics.drawImage(image, 0, 0, null);

	            File imageFile = new File( destinationDir + fileName +"_"+ pageNumber +".png" );// change file format here. Ex: .png, .jpg, .jpeg, .gif, .bmp

	            ImageIO.write(bufferedImage, "png", imageFile);

	            System.out.println(imageFile.getName() +" File created in: "+ destinationFile.getCanonicalPath());
	        } else {
	            System.err.println(sourceFile.getName() +" File not exists");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	*/

}
